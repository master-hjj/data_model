import base64
import time
import uuid
from io import BytesIO

import pandas as pd
import requests
from flask import jsonify,  send_file, Response, stream_with_context


from ..models import ModelApp, Network, AppParams
from .. import db
from config import minio_config
from TrainModel import Train_ML, Train_DML
from ..base import base
import os
from flask_login import login_required, current_user

'''
返回html都用不到，针对前后端分离，都有新的接口
'''


@base.route('/get_image/<id>')  # 返回训练结果到前端，根据需求还要再改，
def get_image(id):
    modelapp = ModelApp.query.get(id)
    appparams = modelapp.appliparams
    appparam = appparams[-1]
    # filename = '{}.png'.format(appparam.result)
    image_path = appparam.image_path
    return send_file(os.environ['app_home'] + fr'/{image_path}')
    # return send_from_directory('app/model_and_data/results', filename)

@base.route('/get_model_Bypath/<path:path>')  # 返回训练结果到前端，根据需求还要再改，
def get_model_bypath(path):
    try:
        return send_file(os.environ['app_home'] + fr'/{path}', as_attachment=True)
    except Exception as e:
        return '文件不存在'


@base.route('/download_modelbypath/<id>')  # 返回训练结果到前端，根据需求还要再改，
def get_modelbypath(id):
    modelapp = ModelApp.query.get(id)
    appparams = modelapp.appliparams
    appparam = appparams[-1]
    model_path = appparam.model_path
    path = fr'http://43.143.230.183:9350/models/{model_path}'
    response = requests.get(path)
    file = BytesIO(response.content)
    return send_file(file, mimetype='pth/pt')

'''
将训练模型所需要的所有参数都返回
'''


@base.route('/train_model2/<id>', methods=['GET'])
def train_model2(id):
    model = ModelApp.query.get(id)
    dataset = model.test_data.ori_dataset.path   # 拿到原始数据集的路径
    input = eval(model.test_data.input)
    output = eval(model.test_data.output)
    print(input)
    print(output)
    network_name = model.network.name
    network_path = model.network.path
    model_params = eval(model.params)
    image_name = str(uuid.uuid4())

    image_path = fr'results/{image_name}.png'
    train_params = {'dataset': dataset,
                    'input': input,
                    'output': output,
                    'network_name': network_name,
                    'network_path': network_path,
                    'model_params': model_params,
                    'image_path': image_path}

    if model.network.is_deep == 0:  # 机器学习
        # try:
            appparam = AppParams(params=str(model_params), image_path=image_path, app_id=id)
            db.session.add(appparam)
            trainModel = Train_ML(**train_params)
            print('---------------------')
            res = trainModel.train()
            print('here')
            model.status = 1
            db.session.commit()
            data = {
                'msg': '训练完成',
                'code': 200
            }

    else:  # 深度学习
        try:
            model_name = str(uuid.uuid4())
            test_name = str(uuid.uuid4())
            test_image = fr'results/{test_name}.png'
            model_path = fr'trained_model/{model_name}.pth'
            # print(test_image)
            # print(model_path)
            train_params['model_path'] = model_path
            train_params['test_image'] = test_image

            appparam = AppParams(params=str(model_params), image_path=image_path, model_path=model_path, app_id=id, test_image=test_image)
            print('-------')
            trainModel = Train_DML(**train_params)  # 深度学习
            print(111)
            eva = trainModel.train()

            appparam.eva = str(eva)
            model.status = 1
            print('训练完成')
            db.session.add(appparam)
            db.session.commit()
            data = {
                    'msg': '训练完成',
                    'code': 200
            }
        except Exception as e:
            db.session.close()
            data = {
                'msg': '训练出错',
                'code': 400
            }

    return jsonify(data)


@base.route('/train_model3/<id>', methods=['GET'])
def train_model3(id):
    """
    最新版训练，将训练封装在网络中，将数据处理，网络，评价指标等都包装在桶内

    """
    model = ModelApp.query.get(id)
    dataset = model.test_data.ori_dataset.path   # 拿到原始数据集的路径
    input = eval(model.test_data.input)
    output = eval(model.test_data.output)
    network_name = model.network.name  # 网络名
    network_path = model.network.path   # 网络地址
    model_params = eval(model.params)   # 模型参数
    image_name = str(uuid.uuid4())      # 图像名loss 图
    image_path = fr'results/{image_name}.png'  # loss图地址

    train_params = {'dataset': dataset,  # 训练所需参数
                    'input': input,
                    'output': output,
                    'network_name': network_name,
                    'network_path': network_path,
                    'model_params': model_params,
                    'image_path': image_path}

    if model.network.is_deep == 0:  # 机器学习
        # try:
            appparam = AppParams(params=str(model_params), image_path=image_path, app_id=id)
            db.session.add(appparam)
            trainModel = Train_ML(**train_params)
            print('---------------------')
            res = trainModel.train()
            print('here')
            model.status = 1
            db.session.commit()
            data = {
                'msg': '训练完成',
                'code': 200
            }

    else:  # 深度学习
        try:
            test_image = fr'results/{str(uuid.uuid4())}.png'
            model_path = fr'trained_model/{str(uuid.uuid4())}.pth'
            # 从桶中读取数据集
            datasets = minio_config.read_file(dataset)
            params = {
                'dataset': datasets,
                'model_params': model_params,
                'input': input,
                'output': output,
            }
            # 从桶中读取网络类
            class_obj = minio_config.load_class_from_file(network_path, 'Train_DML')

            trainModel = class_obj(**params)  # 实例化类

            res = trainModel.train()  # 训练，结果作为字典传过来

            appparam = AppParams(params=str(model_params), app_id=id)
            # 将结果传入桶内
            if res['loss']:
                minio_config.upload_file2(image_path, res['loss'])  # 存loss图
                appparam.image_path = image_path
            if res['model_file']:
                minio_config.upload_file2(model_path, res['model_file'])  # 存模型文件
                appparam.model_path = model_path
            if res['comparison']:
                minio_config.upload_file2(test_image, res['comparison'])  # 存真实值预测值对比图
                appparam.test_image = test_image
            appparam.eva = str(res['eva'])
            model.status = 1
            print('训练完成')
            db.session.add(appparam)
            db.session.commit()
            data = {
                    'msg': '训练完成',
                    'code': 200
            }
        except Exception as e:
            db.session.close()
            data = {
                'msg': '训练出错',
                'code': 400
            }

    return jsonify(data)

@base.route('/delete_train_result/<id>')
@login_required
def delete_train_result(id):
    if ',' not in id:
        appparam = AppParams.query.get(id)
        if appparam:
            minio_config.delete_file(appparam.image_path)
            if appparam.model_application.network.is_deep == 1:
                minio_config.delete_file(appparam.model_path)
            db.session.delete(appparam)
            db.session.commit()
            return '删除成功'
        else:
            db.session.close()
            return '删除失败'
    else:
        id_list = eval(id)
        for i in id_list:
            appparam = AppParams.query.get(i)
            if appparam:
                minio_config.delete_file(appparam.image_path)
                if appparam.model_application.network.is_deep == 1:
                    minio_config.delete_file(appparam.model_path)
                db.session.delete(appparam)
                db.session.commit()
            else:
                db.session.close()
                return '删除失败'
        return '删除成功'


@base.route('/show_userinfo', methods=['GET'])
@login_required
def show_userinfo():
    def generate_loss():
        for epoch in range(10):
            loss = 0.1 * epoch  # 模拟损失值
            # 发送每个 epoch 的训练损失值到前端
            yield f"data: {loss}\n\n"
            time.sleep(0.5)
    return Response(stream_with_context(generate_loss()), mimetype='text/event-stream')

@base.route('/get_ownnetworks', methods=['GET'])
@login_required
def get_ownnetworks():
    user = current_user
    print(user.ID)
    networks = Network.query.filter_by(created_username=user.LOGINNAME)
    networks = [network.to_dict() for network in networks]
    return jsonify(networks)


@base.route("/get_train_results/<id>", methods=['GET'])
@login_required
def get_train_results(id):
    modelapp = ModelApp.query.get(id)
    appparams = modelapp.appliparams
    appparams = [appparams.to_dict() for appparams in appparams]
    appparams = appparams[::-1]
    return jsonify(appparams)


@base.route("/get_all_modelapps", methods=['GET'])
@login_required
def get_all_modelapps():
    modelapps = ModelApp.query.all()
    modelapps = [modeapp.to_dict2() for modeapp in modelapps]
    return jsonify(modelapps)




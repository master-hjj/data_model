
import io
from flask_login import login_required
from nbformat.validator import validators

from werkzeug.utils import secure_filename
from wtforms import StringField

from config import minio_config
from ..models import Network, Dataset, Networkcategory, ModelApp
import os
import sqlalchemy as sa
from .form import UpDatasetForm, UpNetworkForm, UpModelappForm
from ..base import base

from flask import request
from flask_login import current_user
from flask import jsonify

from .. import db

@base.route('/upload_network', methods=['GET', 'POST'])  # 网络模型上传（需要区别身份，管理员还是用户，待完成）
@login_required
def upload_network():
    """
    get方法返回六类
    post需要上传模型名，模型类别，深度学习还是机器学习
    模型参数，英文名对应输入框id为key1,key2,key3...,中文名value1,value2,value3...
    :return:
    """
    if request.method == 'POST':
        user = current_user
        data = request.form
        print(data)
        form = UpNetworkForm(request.form)
        res = {'code': 405, 'msg': ''}
        if form.validate():
            name = form.network_name.data
            category_id = form.network_func.data
            is_deep = form.is_deep.data
            params = {}
            for key, value in data.items():  # 转参数为字典
                if key.startswith('key'):
                    # Extract the index number from the key name
                    index = key[3:]
                    # Get the corresponding value using the index
                    value_key = 'value' + index
                    value_value = data.get(value_key)
                    # Create a new Data object and save it to the database
                    params[value] = value_value
            params = str(params)
            file = request.files.get('file')
            if file is not None:
                # 保存文件到服务器
                filename = secure_filename(file.filename)
                if not filename.endswith('.py'):
                    print('Only py files are allowed')
                    res['msg'] = 'Only py files are allowed'
                    print(res)
                    return jsonify(res)
                # 将保存路径存入数据库
                path = fr'models/{filename}'
                file_data = io.BytesIO(file.read())
                file_data.seek(0)
                resu = minio_config.upload_file(path, file_data)
                if resu:
                    dataset = Network(name=name, category_id=category_id, network_params=str(params), path=path, is_deep=is_deep,
                                      created_username=user.LOGINNAME)
                    db.session.add(dataset)
                    db.session.commit()
                    return '上传成功'
                else:
                    return '文件已存在'
            else:
                print('文件不能为空')
                res['msg'] = '文件不能为空'
                return jsonify(res)
        else:
            print(form.errors)
            res['msg'] = form.errors
            return jsonify(res)
    else:
        networkcats = Networkcategory.query.all()
        networkcats = [netcat.to_dict() for netcat in networkcats]
        # return render_template('upload_network.html', model_funcs=model_funcs)
        return jsonify(networkcats)


def create_dynamic_form(params):  # 根据所选网络加数据验证,都设置字段不能为空
    class DynamicForm(UpModelappForm):
        pass
    for param in params:
        setattr(DynamicForm, param, StringField(param, validators=[validators.DataRequired()]))
    return DynamicForm


@base.route('/upload_modelapp', methods=['POST'])  # 上传网络模型应用，(自定义)
@login_required
def upload_modelapp():
    try:
        user = current_user
        data = request.get_json()
        model_name = data['model_name']
        model_description = data['model_description']
        data_id = data['dataset']  # 拿到测试数据集的id
        network_id = data['network_id']
        network = Network.query.get(network_id)
        nework_params = network.network_params
        db_dict = eval(nework_params)
        keys = db_dict.keys()
        params = {}  # 参数都是数据库读出的列表对应的
        print(keys)
        for key in keys:
            # print(key)
            value = data.get(key)
            # Create a new Data object and save it to the database
            params[key] = value

        model = ModelApp(model_name=model_name,
                         model_description=model_description,
                         data_id=data_id,
                         params=str(params),
                         network_id=network_id,
                         created_username=user.LOGINNAME)
        db.session.add(model)
        db.session.commit()
        return '添加成功'
    except Exception as e:
        print(e)
        return '添加失败'


@base.route('/show_networks', methods=['GET'])
def show_networks():
    username = current_user.LOGINNAME
    # if username == 'admin':
    #     networks1 = Network.query.all()
    # else:
    #     networks1 = Network.query.filter_by(created_username=username).all()
    networks1 = Network.query.all()
    networks = [network.to_dict() for network in networks1]

    # network.netcat.name
    return jsonify(networks)


@base.route('/delete_network/<id>', methods=['GET', 'POST'])
@login_required
def delete_network(id):
    if ',' not in id:
        model = Network.query.get(id)
        if model:
            try:
                minio_config.delete_file(model.path)
                db.session.delete(model)
                db.session.commit()
                data = {
                    'msg': f"删除成功",
                    'code': 200
                }
                return jsonify(data)
            except sa.exc.IntegrityError as e:
                data = {
                    'msg': f"外键约束错误",
                    'code': 400
                }
                return jsonify(data)
        else:
            return '删除失败'
    else:
        id_list = eval(id)
        data = {
            'msg': [],
            'code': []
        }
        for i in id_list:
            model = Network.query.get(i)
            if model:
                try:
                    minio_config.delete_file(model.path)
                    db.session.delete(model)
                    db.session.commit()
                # except sa.exc.IntegrityError as e:
                except sa.exc.IntegrityError as e:
                    data['msg'].append(f"第{i}条数据外键错误")
                    data['code'].append(400)
                    db.session.close()
                    # return '错误'
                else:
                    # data['msg'].append(f"第{i}条数据删除成功")
                    data['code'].append(200)
            else:
                data['msg'].append(f"第{i}条数据不存在")
                data['code'].append(400)
        data['code'] = max(data['code'])
        data['msg'] = str(data['msg']).replace('[', '').replace(']', '')
        return jsonify(data)


@base.route('/get_category_networks/<id>', methods=['GET'])  # 根据类别获取该类别的所有网络
@login_required
def get_category_networks(id):
    """
    获取用户所选的类比，返回该类别下的所有网络
    :return:
    """
    netcat = Networkcategory.query.get(id)
    options = netcat.networks
    networks = [option.to_dict() for option in options]

    return jsonify(networks)


@base.route('/get_network/<id>', methods=['GET'])  # 根据类别获取该类别的所有网络
def get_networks(id):
    """
    获取用户所选网络名，获取该网络的参数列表
    :return:
    """
    network = Network.query.get(id)
    if network:
        params = network.network_params
        params = eval(params)
        return jsonify(params)
    else:
        return 'error'


@base.route('/get_datasets', methods=['GET'])
def get_datasets():
    datasets = Dataset.query.all()
    datasets = [dataset.to_dict() for dataset in datasets]
    return jsonify(datasets)


@base.route('/show_models', methods=['GET'])
def show_models():
    username = current_user.LOGINNAME
    if username == 'admin':
        models = ModelApp.query.all()
    else:
        models = ModelApp.query.filter_by(created_username=username).all()
    # models = ModelApp.query.all()
    models = [model.to_dict() for model in models]
    return jsonify(models)


@base.route('/model_detailparams/<id>')
@login_required
def model_detail(id):
    model = ModelApp.query.get(id)
    params = eval(model.params)
    print(params)
    return jsonify(params)


@base.route('/modify_params/<id>', methods=['POST'])
@login_required
def modify_params(id):
    model = ModelApp.query.get(id)
    # network_params = eval(model.network.network_params)  # 通过网络获取
    network_params = eval(model.params)  # 通过模型获取
    print(network_params)
    params = {}
    keys = network_params.keys()
    print(keys)
    data = request.get_json()
    for key in keys:
        # print(key)
        value = data.get(key)
        # Create a new Data object and save it to the database
        params[key] = value
    print(params)
    model.params = str(params)
    model.status = 0
    try:
        db.session.commit()
        return '修改完成'
    except Exception as e:
        return '修改失败'


@base.route('/delete_model/<id>')  # 模型应用删除，需要修改
@login_required
def model_delete(id):
    if ',' not in id:
        model = ModelApp.query.get(id)
        if model:
            try:
                db.session.delete(model)
                db.session.commit()
                data = {
                    'msg': f"删除成功",
                    'code': 200
                }
                return jsonify(data)
            except sa.exc.IntegrityError as e:
                data = {
                    'msg': f"外键约束错误:{e.orig}",
                    'code': 400
                }
                return jsonify(data)
        else:
            return '删除失败'
    else:
        id_list = eval(id)
        data = {
            'msg': [],
            'code': [],
        }
        for i in id_list:
            model = ModelApp.query.get(i)
            if model:
                try:
                    db.session.delete(model)
                    db.session.commit()
                # except sa.exc.IntegrityError as e:
                except sa.exc.IntegrityError as e:
                    data['msg'].append(f"第{i}条数据外键错误")
                    data['code'].append(400)
                    db.session.close()
                    # return '错误'
                else:
                    # data['msg'].append(f"第{i}条数据删除成功")
                    data['code'].append(200)
            else:
                data['msg'].append(f"第{i}条数据不存在")
                data['code'].append(400)
        data['code'] = max(data['code'])
        data['msg'] = str(data['msg']).replace('[', '').replace(']', '')
        return jsonify(data)


@base.route('/get_TestData_ById/<id>', methods=['GET'])  # 通过原始数据集的id，获取以它为基础的所有测试数据集
@login_required
def get_TestData_ById(id):
    dataset = Dataset.query.get(id)
    testdatas = dataset.testdatas
    testdatas = [testdata.to_dict() for testdata in testdatas]
    return jsonify(testdatas)
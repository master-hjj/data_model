
from app.models import Network, Dataset, Networkcategory,PreprocessDataset, TestDataset,PreprocessMethod

import io
from flask_login import login_required
from nbformat.validator import validators

from werkzeug.utils import secure_filename
from wtforms import StringField

from config import minio_config
import os
import sqlalchemy as sa
from app.routes.form import UpDatasetForm, UpNetworkForm, UpModelappForm,UpPreprocessForm
from app.base import base

from flask import request
from flask_login import current_user
from flask import jsonify

from app import db

@base.route('/dataset/preprocessed-dataset/upload_preprocess_method', methods=['POST'])  # 上传（需要区别身份，管理员还是用户，待完成）
@login_required
def upload_preprocess_method():
    if request.method == 'POST':
        user = current_user
        data = request.form
        # print(data)
        form = UpPreprocessForm(request.form)
        res = {'code': 405, 'msg': ''}
        if form.validate():
            name = form.preprocess_name.data
            description = form.preprocess_description.data
            file = request.files.get('file')
            print(file)
            if file is not None:
                # 保存文件到服务器
                filename = secure_filename(file.filename)
                print(filename)
                if not filename.endswith('.py'):
                    print('Only py files are allowed')
                    res['msg'] = 'Only py files are allowed'
                    print(res)
                    return jsonify(res)
                # 将保存路径存入数据库
                path = fr'preprocess_methods/{filename}'
                file_data = io.BytesIO(file.read())
                file_data.seek(0)
                resu = minio_config.upload_file(path, file_data)
                print(resu)
                if resu:
                    pm= PreprocessMethod(name=name, description=description, path=path,created_username=user.LOGINNAME)
                    db.session.add(pm)
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


@base.route('/dataset/preprocessed-dataset/preprocess/<testdata_id>/<preprocess_id>', methods=['POST'])
@login_required
def preprocess(testdata_id,preprocess_id):
    '''
    先拿到测试数据集
    再拿到原始数据集，两者结合，拿出要处理的数据形成dataframe
    拿到预处理方法的代码里面的处理类，用dataframe实例化
    执行run函数，存储结果到桶里面
    '''
    testdata = TestDataset.query.get(testdata_id)
    username = testdata.created_username
    dataset_id = testdata.origin_dataset
    dataset = Dataset.query.get(dataset_id)
    path = dataset.path
    input = eval(testdata.input)
    output = eval(testdata.output)
    data = minio_config.read_file(path)
    all_column = input+output
    taskdata = data[all_column]

    preprocess_method = PreprocessMethod.query.get(preprocess_id)
    Process = minio_config.load_class_from_file(preprocess_method.path,'Process')
    name = "preprocessed_dataset_" + str(testdata_id) + "_" + str(preprocess_id)+".csv"
    data_description = "采取的预处理方法是"+preprocess_method.name+"，处理的原始文件是"+dataset.name+"。"
    process = Process(name,taskdata)
    processed_csv = process.run()

    path = fr'preprocessed_dataset/{name}'
    file_data = io.BytesIO(processed_csv.read())
    file_data.seek(0)
    resu = minio_config.upload_file(path, file_data)
    print(resu)
    if resu:
        pd = PreprocessDataset(name=name, path=path,
                               data_description = data_description,
                               testdata_id = testdata_id,
                               preprocess_id = preprocess_id,
                               created_username=username)
        db.session.add(pd)
        db.session.commit()
        return '处理成功'
    else:
        return '文件已存在'
import json

from app import db
from datetime import datetime
from sqlalchemy import desc
# 模型model
'''
模型名称
模型需要传入的参数
模型地址
'''


class Network(db.Model):
    __tablename__ = 'network'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    path = db.Column(db.String(255), nullable=False)
    network_params = db.Column(db.String(500), nullable=False)
    category_id = db.Column(db.Integer, db.ForeignKey('netcat.id'), nullable=False)
    is_deep = db.Column(db.Integer, default=0)   # 0表示为机器学习 1表示深度学习
    created_username = db.Column(db.String(100), nullable=False)  # LoginName
    modelapps = db.relationship('ModelApp', backref='network')
    create_time = db.Column(db.DateTime, default=datetime.now())
    def to_dict(self):
        if self.is_deep==0:
            type = '机器学习'
        else:
            type = '深度学习'
        return {'id': self.id, 'name': self.name, 'path':self.path, 'network_params': self.network_params,
                'category': self.netcat.name, 'type': type, 'created_username': self.created_username}


class Networkcategory(db.Model):
    __tablename__ = 'netcat'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    networks = db.relationship('Network', backref='netcat')

    def to_dict(self):
        return {'value': self.id, 'label': self.name}

    def to_dict2(self):
        return {'value': self.name, 'text': self.name}


class ModelApp(db.Model):
    __tablename__ = 'model_application'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    model_name = db.Column(db.String(100), nullable=False)
    model_description = db.Column(db.Text, nullable=False)
    data_id = db.Column(db.Integer, db.ForeignKey('testdata.id', ondelete='CASCADE'), nullable=False)
    # dataset = db.Column(db.String(100), nullable=False)  # 数据集应该存放的也是id,
    params = db.Column(db.String(500), nullable=False)
    network_id = db.Column(db.Integer, db.ForeignKey('network.id', ondelete='CASCADE'), nullable=False)
    appliparams = db.relationship('AppParams', backref='model_application', cascade="all, delete-orphan")
    status = db.Column(db.Integer, default=0)   # 0表示为未训练 1表示训练完成
    created_username = db.Column(db.String(100), nullable=False)
    create_time = db.Column(db.DateTime, default=datetime.now())
    def to_dict(self):
        if self.status == 0:
            percentage = 0
            process = None
            imagePath = None
            modelPath = None
            testImagePath = None
            eva = None
        else:
            process = 'success'
            percentage = 100
            appparams = self.appliparams
            if appparams:
                appparam = appparams[-1]
                imagePath = fr'http://43.143.230.183:9350/models/{appparam.image_path}'
                if self.network.is_deep == 0:  # 机器学习
                    modelPath = None
                    testImagePath = None
                    eva = None
                else:
                    modelPath = fr'http://43.143.230.183:9350/models/{appparam.model_path}' if appparam.model_path else None
                    testImagePath = fr'http://43.143.230.183:9350/models/{appparam.test_image}' if appparam.test_image else None
                    eva = appparam.eva if appparam.eva else None
            else:
                imagePath = None
                modelPath = None
                testImagePath = None
                eva = None

        return {'id': self.id, 'model_name': self.model_name, 'model_description': self.model_description,
                'network_id': self.network_id, 'data_id': self.data_id, 'params': eval(self.params), 'process': process,
                'status': self.status, 'percentage': percentage, 'imagePath': imagePath,
                'modelPath': modelPath, 'created_username': self.created_username, 'testImagePath': testImagePath, 'eva': eva}

    def to_dict2(self):
        return {'id': self.id, 'model_name': self.model_name}

class AppParams(db.Model):
    __tablename__ = 'appparams'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    params = db.Column(db.String(500), nullable=False)
    image_path = db.Column(db.String(255))  # 返回文件名（图像/文件）
    model_path = db.Column(db.String(255))
    app_id = db.Column(db.Integer, db.ForeignKey('model_application.id', ondelete='CASCADE'), nullable=False)
    train_time = db.Column(db.DateTime, default=datetime.now())
    test_image = db.Column(db.String(255))
    eva = db.Column(db.String(255))


    def to_dict(self):

        train_image = fr'http://43.143.230.183:9350/models/{self.image_path}'

        model_path = fr'http://43.143.230.183:9350/models/{self.model_path}'

        test_image = fr'http://43.143.230.183:9350/models/{self.test_image}'

        # eva = eval(self.eva) if self.eva else None
        return {'id': self.id, 'params': self.params, 'train_image': train_image,
                'model_path': model_path, 'train_time': self.train_time, 'test_image': test_image,
                'eva': self.eva}












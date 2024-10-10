import json

from app import db
from datetime import datetime
# from sqlalchemy import desc
# 模型model
'''
模型名称
模型需要传入的参数
模型地址
'''


class Preprocess(db.Model):
    __tablename__ = 'preprocess'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    category = db.Column(db.Integer, default=0)
    filename = db.Column(db.String(255), nullable=False)
    create_username = db.Column(db.String(100), nullable=False)  # LoginName
    create_time = db.Column(db.DateTime, default=datetime.now())
    def to_dict(self):
        return {'id': self.id, 'name': self.name, 
                'category': self.category,'create_username': self.create_username,'create_time': self.create_time,'filename':self.filename}


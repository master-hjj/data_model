from app import db
from datetime import datetime
from sqlalchemy import desc


class Dataset(db.Model):
    __tablename__ = 'datasets'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    data_description = db.Column(db.Text, nullable=False)
    path = db.Column(db.String(100), nullable=False)
    upload_date = db.Column(db.DateTime, default=datetime.now())
    created_username = db.Column(db.String(100), nullable=False)
    created_userrole = db.Column(db.String(100), nullable=False)
    testdatas = db.relationship('TestDataset', backref='ori_dataset')
    def to_dict(self):
        return {'id': self.id, 'name': self.name, 'data_description': self.data_description,
                'upload_date': self.upload_date}


class TestDataset(db.Model):
    __tablename__='testdata'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    input = db.Column(db.String(255), nullable=False)
    output = db.Column(db.String(255), nullable=False)
    origin_dataset = db.Column(db.Integer, db.ForeignKey('datasets.id'), nullable=False)
    create_date = db.Column(db.DateTime, default=datetime.now())
    created_username = db.Column(db.String(100), nullable=False)
    created_userrole = db.Column(db.String(100), nullable=False)
    modelapps = db.relationship('ModelApp', backref='test_data')
    def to_dict(self):
        return {'id': self.id, 'name': self.name, 'origin_dataset': self.ori_dataset.name,
                'create_date': self.create_date}

from app import db
from datetime import datetime
from sqlalchemy import desc

class PreprocessDataset(db.Model):
    __tablename__='preprocessed_dataset'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    data_description = db.Column(db.String(500), nullable=False)
    path = db.Column(db.String(100), nullable=False)
    testdata_id = db.Column(db.Integer, db.ForeignKey('testdata.id', ondelete='CASCADE'), nullable=False)
    create_date = db.Column(db.DateTime, default=datetime.now())
    created_username = db.Column(db.String(100), nullable=False)
    preprocess_id = db.Column(db.Integer, db.ForeignKey('preprocess_method.id', ondelete='SET NULL'))
    method = db.relationship('PreprocessMethod',backref = "preprocessed_dataset")
    def to_dict(self):
        return {'id': self.id, 'name': self.name,
                'data_description':self.data_description,
                'created_username': self.created_username,
                'create_date': self.create_date,
                'preprocess_method_name':self.method.name}
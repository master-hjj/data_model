from app import db
from datetime import datetime
from sqlalchemy import desc

class PreprocessMethod(db.Model):
    __tablename__='preprocess_method'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(500), nullable=False)
    path = db.Column(db.String(100), nullable=False)
    create_date = db.Column(db.DateTime, default=datetime.now())
    created_username = db.Column(db.String(100), nullable=False)
    def to_dict(self):
        return {'id': self.id, 'name': self.name, 'created_username': self.created_username,
                'create_date': self.create_date}
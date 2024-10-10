from app import db
from datetime import datetime
from sqlalchemy import desc

class Rankings(db.Model):
    __tablename__ = 'rankings'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    testdata_id = db.Column(db.Integer, db.ForeignKey('testdata.id', ondelete='CASCADE'), nullable=False)
    apparams_id = db.Column(db.Integer, db.ForeignKey('appparams.id', ondelete='CASCADE'), nullable=False)

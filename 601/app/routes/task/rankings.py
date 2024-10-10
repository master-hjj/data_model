import importlib
import io
import ast
from flask_login import login_required
from werkzeug.utils import secure_filename
from app import create_app, db
from app.models import Network, Dataset, Networkcategory, ModelApp, TestDataset,Rankings,AppParams
import sqlalchemy as sa
from app.base import base
from flask import request
from flask_login import current_user
from flask import jsonify

from app import db
from config import minio_config


class RankingRow:

    row_number = 0

    def __init__(self, created_username,network_name,train_time,mse,mae):
        self.created_username = created_username
        self.network_name = network_name
        # self.preprocessed_datase_name = preprocessed_datase_name
        self.train_time = train_time
        self.mse = mse
        self.mae = mae

    def to_dict(self):
        return {'created_username': self.created_username, 'network_name': self.network_name,
                'train_time': self.train_time,'mse': self.mse,'mae': self.mae}


@base.route('/task/rankings/show_rankings/<testdata_id>', methods=['GET'])
@login_required
def show_rankings(testdata_id):
    rankingrows = []
    rankings = Rankings.query.filter_by(testdata_id=testdata_id).all()
    for item in rankings:
        apparams_id = item.apparams_id
        apparams = AppParams.query.filter_by(id = apparams_id).first()
        app_id = apparams.app_id
        app = ModelApp.query.filter_by(id = app_id).first()
        created_username = app.created_username
        network_name = app.model_name
        # testdata = TestDataset.query.filter_by(id = testdata_id)
        # preprocessed_datase_name = testdata.name
        train_time = apparams.train_time
        eva_dict = ast.literal_eval(apparams.eva)
        mse = eva_dict['mse']
        mae = eva_dict['mae']
        rankingrow = RankingRow(created_username,network_name,
                                train_time,mse,mae)
        rankingrows.append(rankingrow)
    print(rankingrows)
    sorted_rankingrows = sorted(rankingrows, key=lambda rankingrow: rankingrow.mse)
    sorted_rankingrows = [rankingrow.to_dict() for rankingrow in sorted_rankingrows]
    return jsonify(sorted_rankingrows)


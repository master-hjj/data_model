import importlib
import io
import ast
from flask_login import login_required
from werkzeug.utils import secure_filename
from app import create_app, db
from app.models import Network, Dataset, Networkcategory,PreprocessDataset, TestDataset,Rankings,AppParams
import sqlalchemy as sa
from app.base import base
from flask import request
from flask_login import current_user
from flask import jsonify

from app import db
from config import minio_config

@base.route('/task/get_dataset_list/<testdata_id>', methods=['GET'])
@login_required
def get_dataset_list(testdata_id):
    testdata = TestDataset.query.get(testdata_id)
    ppdatasets = PreprocessDataset.query.filter_by(testdata_id=testdata_id).all()
    ret = [{"is_preprocessed":0,"dataset_id":testdata_id,"dataset_name":testdata.name}]
    for i in ppdatasets:
        ret.append({"is_preprocessed":1,"dataset_id":i.id,"dataset_name":i.name})
    return jsonify(ret)


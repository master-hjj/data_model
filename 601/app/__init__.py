from flask import Flask, render_template
from flask_moment import Moment
from flask_sqlalchemy import SQLAlchemy

from config import config
from flask_login import LoginManager
import flask_excel as excel


from flask import json
from datetime import datetime, date

JSONEncoder = json.JSONEncoder

class CustomJSONEncoder(JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime):
            return obj.strftime('%Y-%m-%d %H:%M:%S')
        elif isinstance(obj, date):
            return obj.strftime('%Y-%m-%d')
        else:
            return JSONEncoder.default(self, obj)


loginmanager = LoginManager()
loginmanager.session_protection = 'strong'
#loginmanager.login_view = 'base.login'

moment = Moment()

db = SQLAlchemy()



def create_app(config_name):
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'secret!'
    #  替换默认的json编码器
    app.json_encoder = CustomJSONEncoder
    app.config.from_object(config[config_name])
    config[config_name].init_app(app)

    moment.init_app(app)
    db.init_app(app)
    loginmanager.init_app(app)

    from .base import base as base_blueprint

    app.register_blueprint(base_blueprint)

    excel.init_excel(app)
    return app


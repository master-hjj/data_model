import importlib
import io
import os

import pandas as pd
from minio import Minio, S3Error


basedir = os.path.abspath(os.path.dirname(__file__))

class MinioConfig:
    def __init__(self):
        self.minio_client = Minio('43.143.230.183:9350',
                                     access_key='JbYs2023',
                                     secret_key='JbYs@6F9T8_431-Y7',
                                     secure=False)  # 如果你使用 HTTPS 连接，请将 secure 设置
        self.bucket_name = 'models'

    def upload_file(self, file_path, file_data):
        try:
            self.minio_client.stat_object(self.bucket_name, file_path)
            return False
        except S3Error as err:
            if err.code == 'NoSuchKey':
                self.minio_client.put_object(self.bucket_name, file_path, file_data, len(file_data.getvalue()))
                return True
            else:
                print('Error occurred while checking file: {}'.format(err))
                return False


    def upload_file2(self, file_path, file_data):
        try:
            self.minio_client.put_object(self.bucket_name, file_path, file_data, len(file_data.getvalue()))
            return True
        except S3Error as e:
            return str(e)

    def read_file(self, file_path):
        file_data = self.minio_client.get_object(self.bucket_name, file_path)
        file_content = file_data.read()
        dataframe = pd.read_csv(io.BytesIO(file_content))
        return dataframe

    def download_file(self, file_path):
        try:
            file_data = self.minio_client.get_object(self.bucket_name, file_path)
            return file_data.read()
        except S3Error as e:
            return str(e)

    def load_class_from_file(self, file_path, class_name):
        try:
            file_content = self.download_file(file_path)
            spec = importlib.util.spec_from_loader(class_name, loader=None, origin=class_name, is_package=False)
            module = importlib.util.module_from_spec(spec)
            exec(file_content, module.__dict__)
            return getattr(module, class_name)
        except Exception as e:
            return str(e)

    def delete_file(self, file_path):
        try:
            # 文件存在
            self.minio_client.remove_object(self.bucket_name, file_path)
            return True
        except S3Error as err:
            if err.code == 'NoSuchKey':  # 文件不存在
                return False
            else:
                print('Error occurred while checking file: {}'.format(err))
                return False


minio_config = MinioConfig()

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'hard to guess string'
    SQLALCHEMY_COMMIT_ON_TEARDOWN = True
    FLASKY_MAIL_SUBJECT_PREFIX = '[Flasky]'
    FLASKY_MAIL_SENDER = '119161229@qq.com'
    FLASKY_ADMIN = os.environ.get('FLASKY_ADMIN')
    SQLALCHEMY_TRACK_MODIFICATIONS = True

    @staticmethod
    def init_app(app):
        pass


class DevelopmentConfig(Config):
    DEBUG = True
    MAIL_SERVER = 'smtp.qq.com'
    MAIL_PORT = 587
    MAIL_USE_TLS = True
    MAIL_USERNAME = os.environ.get('MAIL_USERNAME')
    MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD')

    # HOSTNAME = 'mysql.sqlpub.com'
    HOSTNAME = '127.0.0.1'
    PORT = '3306'
    DATABASE = 'data_model'
    USERNAME = 'root'
    PASSWORD = '123456'
    DB_URI = 'mysql+mysqlconnector://{}:{}@{}:{}/{}?charset=utf8'.format(USERNAME, PASSWORD, HOSTNAME, PORT, DATABASE)
    SQLALCHEMY_DATABASE_URI = DB_URI

    # SQLALCHEMY_DATABASE_URI = os.environ.get('DEV_DATABASE_URI') or \
    #                           'mysql+mysqlconnector://root:@127.0.0.1/authbase?charset=utf8&auth_plugin=mysql_native_password'


class TestingConfig(Config):
    TESTING = False
    SQLALCHEMY_DATABASE_URI = os.environ.get('TEST_DATABASE_URI') or \
                              'sqlite:///' + os.path.join(basedir, 'data-test.sqlite')


class ProductionConfig(Config):
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URI') or \
                              'sqlite:///' + os.path.join(basedir, 'data.sqlite')


config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}

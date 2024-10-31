import os

from app import create_app, db
from flask import g, render_template


app = create_app(os.getenv('FLASK_CONFIG') or 'default')
# app = create_app('default')

os.environ['app_home'] = os.path.abspath(os.path.dirname(__file__))

@app.errorhandler(404)
def page_not_found(e):
    return render_template('errors/404.html'), 404


if __name__ == '__main__':
    app.run(host="127.0.0.1", debug=True)

# D:/software/miniconda/envs/backend/python.exe -m flask --app start run  -p 5000 --debug


# -i https://pypi.tuna.tsinghua.edu.cn/simple
from functools import wraps
from flask_login import current_user
from flask import jsonify


def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if current_user.roles[0].ID == '2':
            # 如果不是管理员，显示无权限提示并重定向
            return jsonify({'msg': '您不是管理员，不具有该功能权限', 'code': 401, 'url': '/', })

        return f(*args, **kwargs)

    return decorated_function
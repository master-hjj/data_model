from ..base import base
# from ..models import DeviceInfo as di
from flask import  request, jsonify


@base.get('/index/deviceinfo')
def s():
  1
from ..base import base
from ..models import DeviceInfo as di
from flask import render_template, request, jsonify
# import asyncio
# import websockets
from flask_login import login_required


@base.route('/index/deviceinfo', methods=['GET'])
@login_required
def grid_occupancy():
    device_info = di.DeviceInfo().to_json()
    # di.DeviceInfo().start_loop()


    return jsonify({'device_info': device_info, 'code': 200})

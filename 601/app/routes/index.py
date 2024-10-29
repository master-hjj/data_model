from ..base import base
from flask import render_template
from flask_login import login_user, logout_user, login_required, \
    current_user
from flask import g, jsonify
from ..models import Resource, Organization, ResourceType,Role
from ..models.Role import role_resource_table


def sort_router_by_seq(router):
    sorted_router = sorted(router, key=lambda x: x['seq'])
    for router in sorted_router:
        if 'children' in router:
            router['children'] = sort_router_by_seq(router['children'])
    return sorted_router


@base.route('/getRouters')
@login_required
def getRouters():
    resources = Resource.query.join(ResourceType, Resource.type).filter(Resource.SYRESOURCE_ID == None).all()
    # print(resources)
    router_list = [res.to_router_json() for res in resources]
    # print(router_list)
    sorted_router = sort_router_by_seq(router_list)
    # router = sorted(routerlist, key=lambda x: x['seq'])
    return jsonify({'msg': '操作成功', 'code': 200, "data": sorted_router})

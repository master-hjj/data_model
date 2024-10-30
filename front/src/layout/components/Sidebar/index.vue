<template>
    <div :class="{'has-logo':showLogo}" :style="{ backgroundColor: settings.sideTheme === 'theme-dark' ? variables.menuBackground : variables.menuLightBackground }">
        <logo v-if="showLogo" :collapse="isCollapse" />
        <el-scrollbar :class="settings.sideTheme" wrap-class="scrollbar-wrapper">
            <el-menu
                :default-active="activeMenu"
                :collapse="isCollapse"
                :background-color="settings.sideTheme === 'theme-dark' ? variables.menuBackground : variables.menuLightBackground"
                :text-color="settings.sideTheme === 'theme-dark' ? variables.menuColor : variables.menuLightColor"
                :unique-opened="true"
                :active-text-color="settings.theme"
                :collapse-transition="false"
                mode="vertical"
            >
                <sidebar-item
                    v-for="(route, index) in filteredSidebarRouters"
                    :key="route.path + index"
                    :item="route"
                    :base-path="route.path"
                />
            </el-menu>
        </el-scrollbar>
    </div>
</template>

<script>
import { mapGetters, mapState } from "vuex";
import Logo from "./Logo";
import SidebarItem from "./SidebarItem";
import variables from "@/assets/styles/variables.scss";
import { getRouters } from "@/api/menu"; // 引入接口请求

export default {
    components: { SidebarItem, Logo },
    computed: {
        ...mapState(["settings"]),
        ...mapGetters(["sidebarRouters", "sidebar"]),

        filteredSidebarRouters() {
            const userRoles = this.$store.state.user.roles; // 获取当前用户角色
            return this.sidebarRouters
                .map(route => {
                    const filteredRoute = { ...route }; // 创建当前菜单项的副本

                    // 递归过滤子菜单
                    if (filteredRoute.children) {
                        filteredRoute.children = filteredRoute.children.filter(child => {
                            // 如果 meta.roles 为空或不存在，则所有角色可见；否则，仅 meta.roles 内的角色可见
                            return !child.meta?.roles || child.meta.roles.length === 0 || child.meta.roles.some(role => userRoles.includes(role));
                        });
                    }

                    // 判断父菜单项本身的可见性
                    const isRouteVisible = !filteredRoute.meta?.roles || 
                        filteredRoute.meta.roles.length === 0 || 
                        filteredRoute.meta.roles.some(role => userRoles.includes(role));

                    // 仅返回符合角色权限的路由和子路由
                    return (filteredRoute.children && filteredRoute.children.length > 0) || isRouteVisible ? filteredRoute : null;
                })
                .filter(route => route !== null); // 清除无效路由
        },


        activeMenu() {
            const route = this.$route;
            const { meta, path } = route;
            if (meta.activeMenu) {
                return meta.activeMenu;
            }
            return path;
        },
        showLogo() {
            return this.$store.state.settings.sidebarLogo;
        },
        variables() {
            return variables;
        },
        isCollapse() {
            return !this.sidebar.opened;
        }
    },
    mounted() {
        getRouters().then(response => {
            console.log("接口返回的数据:", response.data); // 打印接口返回的数据
        }).catch(error => {
            console.error("获取路由数据失败:", error);
        });
    }
};
</script>


<template>
  <div class="app-container">
    <el-row>
      <el-col :span="24" class="card-box">
        <el-card>
          <div slot="header"><span>基本信息</span></div>
          <div class="el-table el-table--enable-row-hover el-table--medium">
            <table cellspacing="0" style="width: 100%">
              <tbody>
                <tr>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">Redis版本</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{ cache.info.redis_version }}
                    </div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">运行模式</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{
                        cache.info.redis_mode == "standalone" ? "单机" : "集群"
                      }}
                    </div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">端口</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{ cache.info.tcp_port }}
                    </div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">客户端数</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{ cache.info.connected_clients }}
                    </div>
                  </td>
                </tr>
                <tr>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">运行时间(天)</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{ cache.info.uptime_in_days }}
                    </div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">使用内存</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{ cache.info.used_memory_human }}
                    </div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">使用CPU</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{
                        parseFloat(cache.info.used_cpu_user_children).toFixed(2)
                      }}
                    </div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">内存配置</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{ cache.info.maxmemory_human }}
                    </div>
                  </td>
                </tr>
                <tr>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">AOF是否开启</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{ cache.info.aof_enabled == "0" ? "否" : "是" }}
                    </div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">RDB是否成功</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{ cache.info.rdb_last_bgsave_status }}
                    </div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">Key数量</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.dbSize">
                      {{ cache.dbSize }}
                    </div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell">网络入口/出口</div>
                  </td>
                  <td class="el-table__cell is-leaf">
                    <div class="cell" v-if="cache.info">
                      {{ cache.info.instantaneous_input_kbps }}kps/{{
                        cache.info.instantaneous_output_kbps
                      }}kps
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </el-card>
      </el-col>

      <el-col :span="12" class="card-box">
        <el-card>
          <div slot="header"><span>命令统计</span></div>
          <div class="el-table el-table--enable-row-hover el-table--medium">
            <div ref="commandstats" style="height: 420px" />
          </div>
        </el-card>
      </el-col>

      <el-col :span="12" class="card-box">
        <el-card>
          <div slot="header">
            <span>内存信息</span>
          </div>
          <div class="el-table el-table--enable-row-hover el-table--medium">
            <div ref="usedmemory" style="height: 420px" />
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getCache } from "@/api/monitor/cache";
import echarts from "echarts";

export default {
  name: "Server",
  data() {
    return {
      // 统计命令信息
      commandstats: null,
      // 使用内存
      usedmemory: null,
      // cache信息
      cache: [],

      chen: {
        commandStats: [
          {
            name: "git",
            value: "207",
          },
          {
            name: "get",
            value: "213",
          },
          {
            name: "post",
            value: "111",
          },
        ],
        info: {
          aof_rewrite_scheduled: "0",
          number_of_cached_scripts: "6",
          mem_clients_slaves: "0",
          keyspace_misses: "27236",
          mem_allocator: "jemalloc-5.1.0",
          multiplexing_api: "epoll",
          aof_last_write_status: "ok",
          used_memory_peak_perc: "24.27%",
          run_id: "a83fe9cb173376d9cd893432aed6b6d6f8a0f6f7",
          uptime_in_seconds: "54221010",
          maxmemory: "0",
          active_defrag_hits: "0",
          atomicvar_api: "atomic-builtin",
          total_system_memory_human: "7.38G",
          gcc_version: "4.8.5",
          second_repl_offset: "-1",
          arch_bits: "64",
          master_repl_offset: "0",
          instantaneous_output_kbps: "0.00",
          total_commands_processed: "5671508",
          repl_backlog_size: "1048576",
          sync_full: "0",
          sync_partial_err: "0",
          aof_last_cow_size: "0",
          configured_hz: "10",
          used_memory_startup: "791336",
          mem_clients_normal: "414474",
          used_cpu_user: "32396.590381",
          aof_enabled: "0",
          redis_mode: "standalone",
          rdb_changes_since_last_save: "43",
          used_memory_lua: "49152",
          redis_build_id: "6ad10c5f357d0c98",
          connected_slaves: "0",
          expired_keys: "22113",
          used_memory: "1656168",
          active_defrag_misses: "0",
          active_defrag_key_misses: "0",
          used_memory_rss: "7852032",
          rdb_last_bgsave_status: "ok",
          process_id: "1564",
          rejected_connections: "0",
          master_replid: "5d5f0baf9916fb92f3918568e9a1ed669acc1c64",
          used_memory_rss_human: "7.49M",
          used_memory_scripts: "9104",
          rdb_bgsave_in_progress: "0",
          rdb_last_cow_size: "598016",
          cluster_enabled: "0",
          tcp_port: "6379",
          os: "Linux 3.10.0-957.21.3.el7.x86_64 x86_64",
          mem_replication_backlog: "0",
          aof_current_rewrite_time_sec: "-1",
          allocator_rss_ratio: "2.61",
          used_memory_overhead: "1229194",
          repl_backlog_histlen: "0",
          slave_expires_tracked_keys: "0",
          used_cpu_sys: "22403.694067",
          role: "master",
          used_memory_dataset_perc: "49.37%",
          expired_stale_perc: "0.00",
          allocator_frag_ratio: "1.31",
          client_recent_max_input_buffer: "2",
          aof_last_bgrewrite_status: "ok",
          used_memory_peak_human: "6.51M",
          hz: "10",
          used_memory_human: "1.58M",
          maxmemory_policy: "noeviction",
          rss_overhead_ratio: "1.67",
          mem_fragmentation_ratio: "5.92",
          rdb_last_bgsave_time_sec: "0",
          allocator_allocated: "1382736",
          used_memory_dataset: "426974",
          blocked_clients: "0",
          used_cpu_sys_children: "9.985084",
          repl_backlog_active: "0",
          used_cpu_user_children: "22.983138",
          sync_partial_ok: "0",
          aof_rewrite_in_progress: "0",
          redis_git_sha1: "00000000",
          rdb_current_bgsave_time_sec: "-1",
          active_defrag_running: "0",
          aof_last_rewrite_time_sec: "-1",
          master_replid2: "0000000000000000000000000000000000000000",
          config_file: "/etc/redis/6379.conf",
          lazyfree_pending_objects: "0",
          used_memory_scripts_human: "8.89K",
          loading: "0",
          db5: "keys=104,expires=28,avg_ttl=5226497549",
          db4: "keys=29,expires=0,avg_ttl=0",
          allocator_rss_bytes: "2899968",
          pubsub_channels: "0",
          used_memory_lua_human: "48.00K",
          db0: "keys=106,expires=6,avg_ttl=76351644",
          active_defrag_key_hits: "0",
          allocator_frag_bytes: "423600",
          migrate_cached_sockets: "0",
          redis_git_dirty: "0",
          total_system_memory: "7919116288",
          mem_aof_buffer: "0",
          rss_overhead_bytes: "3145728",
          client_recent_max_output_buffer: "0",
          connected_clients: "9",
          mem_fragmentation_bytes: "6524560",
          lru_clock: "4097422",
          pubsub_patterns: "0",
          expired_time_cap_reached_count: "0",
          repl_backlog_first_byte_offset: "0",
          total_net_output_bytes: "101708305",
          executable: "/usr/local/bin/redis-server",
          evicted_keys: "0",
          total_connections_received: "60143",
          allocator_active: "1806336",
          mem_not_counted_for_evict: "0",
          redis_version: "5.0.5",
          total_net_input_bytes: "189315751",
          latest_fork_usec: "350",
          maxmemory_human: "0B",
          used_memory_peak: "6822840",
          allocator_resident: "4706304",
          keyspace_hits: "126530",
          uptime_in_days: "627",
          instantaneous_input_kbps: "0.00",
          instantaneous_ops_per_sec: "0",
          rdb_last_save_time: "1698596187",
        },
        dbSize: 106,
      },
    };
  },
  created() {
    // this.openLoading();
    // this.getList1();
  },
  mounted(){
    this.getList1();
  },
  methods: {
    /** 查缓存询信息 */
    getList1() {
      //自己写的
      this.cache = this.chen;
      // this.$modal.closeLoading();
      this.commandstats = echarts.init(this.$refs.commandstats, "macarons");
      this.commandstats.setOption({
        tooltip: {
          trigger: "item",
          formatter: "{a} <br/>{b} : {c} ({d}%)",
        },
        series: [
          {
            name: "命令",
            type: "pie",
            roseType: "radius",
            radius: [15, 95],
            center: ["50%", "38%"],
            data: this.cache.commandStats,
            animationEasing: "cubicInOut",
            animationDuration: 1000,
          },
        ],
      });
      this.usedmemory = echarts.init(this.$refs.usedmemory, "macarons");
      this.usedmemory.setOption({
        tooltip: {
          formatter: "{b} <br/>{a} : " + this.cache.info.used_memory_human,
        },
        series: [
          {
            name: "峰值",
            type: "gauge",
            min: 0,
            max: 1000,
            detail: {
              formatter: this.cache.info.used_memory_human,
            },
            data: [
              {
                value: parseFloat(this.cache.info.used_memory_human),
                name: "内存消耗",
              },
            ],
          },
        ],
      });
      //end
    },
    getList() {
      getCache().then((response) => {
        this.cache = response.data;
        this.$modal.closeLoading();

        this.commandstats = echarts.init(this.$refs.commandstats, "macarons");
        this.commandstats.setOption({
          tooltip: {
            trigger: "item",
            formatter: "{a} <br/>{b} : {c} ({d}%)",
          },
          series: [
            {
              name: "命令",
              type: "pie",
              roseType: "radius",
              radius: [15, 95],
              center: ["50%", "38%"],
              data: response.data.commandStats,
              animationEasing: "cubicInOut",
              animationDuration: 1000,
            },
          ],
        });
        this.usedmemory = echarts.init(this.$refs.usedmemory, "macarons");
        this.usedmemory.setOption({
          tooltip: {
            formatter: "{b} <br/>{a} : " + this.cache.info.used_memory_human,
          },
          series: [
            {
              name: "峰值",
              type: "gauge",
              min: 0,
              max: 1000,
              detail: {
                formatter: this.cache.info.used_memory_human,
              },
              data: [
                {
                  value: parseFloat(this.cache.info.used_memory_human),
                  name: "内存消耗",
                },
              ],
            },
          ],
        });
      });
    },
    // 打开加载层
    openLoading() {
      this.$modal.loading("正在加载缓存监控数据，请稍候！");
    },
  },
};
</script>

server_ip_list = [
    "10.11.1.2"
    , "10.11.1.4"
    , "10.11.1.6"
    , "10.11.1.8"
    , "10.11.1.10"
    , "10.11.1.12"
    , "10.11.1.16"
    , "10.11.1.18"
    , "10.11.1.20"
    , "10.11.1.22"
    , "10.11.4.52"
    , "10.11.4.54"
    , "10.11.4.58"
    , "10.11.4.60"
    , "10.11.4.62"
    , "10.11.4.64"
    , "10.11.4.66"
    , "10.11.4.68"
]

result = ""
for item in server_ip_list:
    result += """  - job_name: 'node_exporter_nfs_%s'
    metrics_path: '/metrics'
    static_configs:
    - targets: ['%s:9100']\n""" % (item, item)
print(result)

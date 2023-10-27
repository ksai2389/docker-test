# docker compose startup (preferred method)

    # install docker compose if it is not already installed
    sudo apt install -y docker-compose-plugin
    docker compose -f /prj/omnilin/users/omnici/dockers-repo/node-exporter/compose.yaml up -d

# docker run startup (in case docker compose is unavailable)

    docker run --restart unless-stopped --name node_exporter -d --net="host" --pid="host" -v "/:/host:ro,rslave" docker-registry.qualcomm.com/xrresearch/prom/node-exporter:v1.5.0 --path.rootfs=/host

resource "lxd_volume" "aliaconda_home" {
  name = "aliaconda-home"
  pool = lxd_storage_pool.dpool.id
}

resource "lxd_cached_image" "centos8" {
  source_remote = "images"
  source_image  = "centos/8-Stream/cloud"
}

resource "lxd_container" "aliaconda" {
  name = "aliaconda"
  # zerotier does not yet support centos 9
  image = lxd_cached_image.centos8.fingerprint

  config = yamldecode(file("${var.config_dir}/aliaconda.yml"))

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent = var.exposed_bridge
    }
  }

  device {
    name = "homevol"
    type = "disk"
    properties = {
      path = "/home"
      source = lxd_volume.aliaconda_home.name
      pool = lxd_volume.aliaconda_home.pool
    }
  }

  device {
    name = "rootvol"
    type = "disk"
    properties = {
      path = "/"
      pool = lxd_storage_pool.dpool.id
    }
  }
}

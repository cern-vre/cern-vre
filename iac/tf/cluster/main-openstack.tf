# Openstack Resources (cannot be changed after applied due to limitations of the OpenStack tf provider)

data "openstack_containerinfra_clustertemplate_v1" "cluster_template" {
  name = var.cluster-template-name
}

resource "openstack_compute_keypair_v2" "openstack_cluster_keypair" {
  name = var.cluster-keypair-name
}

resource "openstack_containerinfra_cluster_v1" "openstack_cluster" {
  name                = var.cluster-name
  cluster_template_id = data.openstack_containerinfra_clustertemplate_v1.cluster_template.id # 22a4c77f-cfe3-47bb-8006-31d02375a3f3
  master_count        = 3
  node_count          = 24
  keypair             = var.cluster-keypair-name
  merge_labels        = true
  flavor              = "m2.xlarge"
  master_flavor       = "m2.medium"
  labels = {
    cern_enabled             = "true"
    cvmfs_enabled            = "true"
    cvmfs_storage_driver     = "true"
    eos_enabled              = "true"
    monitoring_enabled       = "true"
    metrics_server_enabled   = "true"
    ingress_controller       = "nginx"
    logging_producer         = var.logging-producer
    logging_installer        = "helm"
    logging_include_internal = "true"
    grafana_admin_passwd     = "admin"
    keystone_auth_enabled    = "true"
    auto_scaling_enabled     = "true"
    min_node_count           = "4"
    max_node_count           = "24"
  }
  provisioner "local-exec" {
    command = "sh ../../scripts/post_cluster_setup.sh"
    environment = {
      cluster = var.cluster-name
    }
  }
}

resource "openstack_blockstorage_volume_v3" "volume_1_reana" {
  name        = "reana_vol1"
  description = "Volume for reana"
  size        = 500
  volume_type = "standard"
}

resource "openstack_sharedfilesystem_share_v2" "share_1_reana" {
  name        = "reana_sh1"
  description = "Share for reana"
  share_proto = "CEPHFS"
  size        = 1000
  share_type  = "Meyrin CephFS"
}

data "openstack_sharedfilesystem_share_v2" "share_1_reana" {
  name = "reana_sh1"
}
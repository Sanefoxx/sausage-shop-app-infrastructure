terraform {
 required_providers {
  yandex = {
  source  = "yandex-cloud/yandex"
  version = "0.61.0"
  }
 }
}

provider "yandex" {
 token     = "t1.9euelZqTj8iQmc6TkY2WlIuSi46Xze3rnpWakI2Vx5uQjpuLlMqUyc-Kzpfl8_crJQZp-e9LZAFM_N3z92tTA2n570tkAUz8.tF335wIz83jsf_mzjSG4Jy8zkPwyfqTNlgLa8fLwdl1IHrtNDHxsnHRnx5m3FLjm1EDSlDiYeN8bdnN1xqUyBQ"
 cloud_id  = "b1g3jddf4nv5e9okle7p"
 folder_id = "b1ggoah947u3kc4j9m7i"
 zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
    name = "chapter5-lesson2-aleksandr-lisitsin"

    resources {
        cores  = 2
        memory = 2
    }

    boot_disk {
        initialize_params {
            image_id = "fd80qm01ah03dkqb14lc"
        }
    }

    network_interface {
        subnet_id = "e9bq7u62i4q21jq25n5j"
        nat       = false
    }

    metadata = {
        user-data = "${file("/home/student/example-01/meta.txt")}"
    }
}

output "ip_address" {
    value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}
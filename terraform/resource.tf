resource "yandex_compute_instance" "vm" {
    count = var.vm_count

    name = "chapter5-lesson2-aleksandr-lisitsin-${count.index}"

    resources {
        cores  = 2
        memory = 2
    }

    boot_disk {
        initialize_params {
            image_id = var.os_properties
        }
    }

    network_interface {
        subnet_id = var.yandex_cloud_subnet_id
        nat       = false
    }

    metadata = {
        user-data = "${file("/home/student/example-01/meta.txt")}"
    }
}

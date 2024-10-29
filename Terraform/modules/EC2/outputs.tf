output "instance_id_1" {
    value = aws_instance.frontend_az1_server.id
}

output "instance_id_2" {
    value = aws_instance.backend_az2_server.id
}

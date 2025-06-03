
ec2_ip=$1
pem_file=$2

ansible-playbook -i "$ec2_ip," --private-key $pem_file ansible/install_docker.yml
ansible-playbook -i "$ec2_ip," --private-key $pem_file ansible/install_nginx.yml
ansible-playbook -i "$ec2_ip," --private-key $pem_file ansible/deploy_app.yml


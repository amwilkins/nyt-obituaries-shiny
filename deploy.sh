apt install -y openssh-client

# Decode SSH key
echo "${ACTION_KEY}" > ssh_key
chmod 600 ssh_key # private keys need to have strict permission to be accepted by SSH agent


echo "Deploying via remote SSH"
ssh -i ssh_key "root@${SERVER_HOSTNAME}" \
  "docker pull amwilkins/obit:latest \
  && docker stop obit \
  && docker rm obit \
  && docker run -d --name obit -p 3838:3838 amwilkins/obit:latest \
  && docker system prune -af" # remove unused images to free up space

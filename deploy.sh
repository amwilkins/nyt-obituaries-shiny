# Decode SSH key
echo "${ACTION_KEY}" | base64 -d > ssh_key
chmod 600 ssh_key # private keys need to have strict permission to be accepted by SSH agent

cat ssh_key


echo "Deploying via remote SSH"
ssh -i ssh_key "root@74.208.91.172" \
  "docker pull amwilkins/obit:latest \
  && docker stop obit \
  && docker rm obit \
  && docker run -d --name obit -p 3838:3838 amwilkins/obit:latest \
  && docker system prune -af" # remove unused images to free up space

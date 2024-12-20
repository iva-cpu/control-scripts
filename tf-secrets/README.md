tf-secrets

Module to create secrets in AWS Secrets Manager from Jenkins secrets using base64 encoding.

List of secrets to be created in Jenkins to pass to tf-secrets module:
  passing as string:
  - mapbox
  - fcm_token    
  passing as file:
  - rootca          
  - apns_certificate
  - apns_key       
  - private_key      

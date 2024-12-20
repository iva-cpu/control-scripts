#!/bin/bash -x

#shopt -s nullglob

script_folder=($PWD)

yaml_files=($script_folder/../config_uploader/result/yaml_taker_qr/deploy/*.yaml)
# yaml_files1=($script_folder/../config_uploader/result/yaml_taker_qr/deploy/)

inventory=($script_folder/../inventory/all/hosts)
list=($script_folder/list.txt)

host1=$(cat $script_folder/../server_name/shared_auth.yaml | grep shared-biom | sort -n | tail -n 1 | cut -d: -f1)
host2=$(cat $script_folder/../server_name/shared_wms.yaml | grep shared-wms | sort -n | tail -n 1 | cut -d: -f1)

s_biom_path=($script_folder/../deploy/deploy_shared_auth/)
s_biom_group_vars=($script_folder/../deploy/deploy_shared_auth/playbooks/group_vars/all)
s_biom_playbook=(playbooks/deploy_shared_auth.yaml)

entity_serv_path=($script_folder/../deploy/deploy_entity_service/)
entity_serv_group_vars=($script_folder/../deploy/deploy_entity_service/playbooks/group_vars/all)
entity_serv_playbook=(playbooks/deploy_entity_service.yaml)

wms_serv_path=($script_folder/../deploy/deploy_wms_service/)
wms_serv_group_vars=($script_folder/../deploy/deploy_wms_service/playbooks/group_vars/all)
wms_serv_playbook=(playbooks/deploy_wms_service.yaml)

notification_serv_path=($script_folder/../deploy/notification_service/)
notification_serv_group_vars=($script_folder/../deploy/notification_service/playbooks/group_vars/all)
notification_serv_playbook=(playbooks/notification_service.yaml)


del_biom_path=($script_folder/../delete/delete_shared_auth/)
del_biom_group_vars=($script_folder/../delete/delete_shared_auth/playbooks/group_vars/all)
del_biom_playbook=(playbooks/delete_shared_auth.yaml)

del_entity_path=($script_folder/../delete/delete_entity_service/)
del_entity_group_vars=($script_folder/../delete/delete_entity_service/playbooks/group_vars/all)
del_entity_playbook=(playbooks/delete_entity_service.yaml)

del_wms_path=($script_folder/../delete/delete_wms_service/)
del_wms_group_vars=($script_folder/../delete/delete_wms_service/playbooks/group_vars/all)
del_wms_playbook=(playbooks/delete_wms_service.yaml)

del_notification_path=($script_folder/../delete/delete_notification_service/)
del_notification_group_vars=($script_folder/../delete/delete_notification_service/playbooks/group_vars/all)
del_notification_playbook=(playbooks/delete_notification_service.yaml)



if ((${#yaml_files[@]}))
then

  ls | grep *.yaml #;

else
  echo "Files not found."
  exit 0 #;
fi

for f in ${yaml_files[@]} #;

do
  filename=$(basename -- "$f")

  echo "Checking $filename ......"
  cat $list | grep $filename

  if [[ $(echo $?) -ne 0 ]]

    then
    echo "Service ${filename%%.*} ready to deploy."
    echo "Checking service type..."
    cd $script_folder/../config_uploader/result/yaml_taker_qr/deploy/
    product=$(cat $filename | grep product | awk '{print $2}')


    if [[ $product = modules ]]
      then
      echo "modules"

    	if [[ $(cat $filename | grep auth_status | cut -d: -f2 | cut -d ' ' -f2) == Pending ]]
    	  then
        cp $filename $s_biom_group_vars
        cd $s_biom_path && ansible-playbook -i $inventory $s_biom_playbook

        if [ $(echo $?) -eq 0 ];
          then
          echo "Shared BIOM ${filename%%.*} successfully deployed."
          cd $script_folder/../
          python3 -m config_uploader.yaml_loader
          else
          echo "Deploy ${filename%%.*} failed"
	        cd $script_folder/../config_uploader/result/yaml_taker_qr/deploy
          cp $filename $del_biom_group_vars
          cd $del_biom_path && ansible-playbook -i $inventory $del_biom_playbook
          echo "Auth_service ${filename%%.*} deleted"
        fi


      elif [[ $(cat $filename | grep entity_status | cut -d: -f2 | cut -d ' ' -f2) == Pending ]]
        then
        cp $filename $entity_serv_group_vars
        cd $entity_serv_path && ansible-playbook -i $inventory $entity_serv_playbook

        if [ $(echo $?) -eq 0 ];
          then
          echo "Entity service ${filename%%.*} successfully deployed."
          cd $script_folder/../
          python3 -m config_uploader.yaml_loader
          else
          echo "Deploy ${filename%%.*} failed"
          cd $script_folder/../config_uploader/result/yaml_taker_qr/deploy
          cp $filename $del_entity_group_vars
          cd $del_entity_path && ansible-playbook -i $inventory $del_entity_playbook
          echo "Entity_service ${filename%%.*} deleted"
        fi

	    elif [[ $(cat $filename | grep wms_status | cut -d: -f2 | cut -d ' ' -f2) == Pending ]]
        then
        cp $filename $wms_serv_group_vars
        cd $wms_serv_path && ansible-playbook -i $inventory $wms_serv_playbook

        if [ $(echo $?) -eq 0 ];
          then
          echo "WMS service ${filename%%.*} successfully deployed."
          cd $script_folder/../
          python3 -m config_uploader.yaml_loader
          else
          echo "Deploy ${filename%%.*} failed"
	        cd $script_folder/../config_uploader/result/yaml_taker_qr/deploy
          cp $filename $del_wms_group_vars
          cd $del_wms_path && ansible-playbook -i $inventory $del_wms_playbook
          echo "Wms_service ${filename%%.*} deleted"
        fi

      elif [[ $(cat $filename | grep notification_status | cut -d: -f2 | cut -d ' ' -f2) == Pending ]]
        then
        cp $filename $notification_serv_group_vars
        cd $notification_serv_path && ansible-playbook -i $inventory $notification_serv_playbook

        if [ $(echo $?) -eq 0 ];
          then
          echo "NOTIFICATION service ${filename%%.*} successfully deployed."
          cd $script_folder/../
          python3 -m config_uploader.yaml_loader
          else
          echo "Deploy ${filename%%.*} failed"
          cd $script_folder/../config_uploader/result/yaml_taker_qr/deploy
          cp $filename $del_notification_group_vars
          cd $del_notification_path && ansible-playbook -i $inventory $del_notification_playbook
          echo "Notification_service ${filename%%.*} deleted"
        fi
      fi

    elif [[ $product = dedicated_wms ]]
      then
      echo "dedicated_wms"

        d_wms_path=($script_folder/../deploy/deploy_dedicated_wms)
        d_wms_group_vars=($script_folder/../deploy/deploy_dedicated_wms/playbooks/group_vars/all)
        d_wms_inventory=(inventory/deploy_dedicated_wms)
        d_wms_playbook=(playbooks/deploy_dedicated_wms.yaml)

      cp $filename $d_wms_group_vars
      cd $d_wms_path && ansible-playbook -i $d_wms_inventory $d_wms_playbook

      if [ $(echo $?) -eq 0 ];
        then
        echo "Dedicated WMS ${filename%%.*} successfully deployed." && echo $filename >> $list
        cd $script_folder/../config_uploader/
        python3.7 -m config_uploader.yaml_loader
        else
        echo "Deploy ${filename%%.*} failed"
      fi

    elif [[ $product = dedicated_biom ]]
      then
      echo "dedicated_biom"

        d_biom_path=($script_folder/../deploy/deploy_dedicated_auth)
        d_biom_group_vars=($script_folder/../deploy/deploy_dedicated_auth/playbooks/group_vars/all)
        d_biom_inventory=(inventory/deploy_dedicated_auth)
        d_biom_playbook=(playbooks/deploy_dedicated_auth.yaml)

      if [ $(cat $filename | grep auth_status | cut -d: -f2 | cut -d ' ' -f2) == Pending ]
        then
        cp $filename $d_biom_group_vars
        cd $d_biom_path && ansible-playbook -i $d_biom_inventory $d_biom_playbook

	      if [ $(echo $?) -eq 0 ];
          then
          echo "Dedicated BIOM ${filename%%.*} successfully deployed." && echo $filename >> $list
          cd $script_folder/../config_uploader/
          python3.7 -m config_uploader.yaml_loader
          else
          echo "Deploy ${filename%%.*} failed"
        fi
      fi
    fi
  else
     echo "Service already deployed"
     cd $script_folder
     exit 0
  fi
done

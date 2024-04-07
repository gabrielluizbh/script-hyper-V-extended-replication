#﻿# Script para Habilitar a Replicação estendida do Hyper-V Réplica em ambiente de domínio - Créditos Gabriel Luiz - www.gabrielluiz.com ##



## Habilitando a réplica no Hyper-V em cada host do Hyper-V. ##


Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos -ReplicationAllowedFromAnyServer $False # Sem certificado SSL, autenticação por Kerberos, devemos especificar o local de armazenamento, o servidor primário e o grupo de confiança.

New-VMReplicationAuthorizationEntry -AllowedPrimaryServer HYRA.gabrielluiz.bh -ReplicaStorageLocation "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks" -TrustGroup Replica # Especifica o servidor primário, armazenamento no local C:\ProgramData\Microsoft\Windows\Virtual Hard Disks e o grupo de confiança.

New-VMReplicationAuthorizationEntry -AllowedPrimaryServer HYRB.gabrielluiz.bh -ReplicaStorageLocation "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks" -TrustGroup Replica # Especifica o servidor primário, armazenamento no local C:\ProgramData\Microsoft\Windows\Virtual Hard Disks e o grupo de confiança.

New-VMReplicationAuthorizationEntry -AllowedPrimaryServer HYRC.gabrielluiz.bh -ReplicaStorageLocation "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks" -TrustGroup Replica # Especifica o servidor primário, armazenamento no local C:\ProgramData\Microsoft\Windows\Virtual Hard Disks e o grupo de confiança.



## Explicação do comando Set-VMReplicationServer. ##



# Configura um host como um servidor de réplica. Habilitando o Hyper-V réplica usando a autenticação por Kerberos.


## Explicação do comando New-VMReplicationAuthorizationEntry. ##

# Cria uma nova entrada de autorização que permite que um ou mais servidores primários repliquem dados para um servidor de réplica especificado.



# Observações:


# Todos os comandos devem ser executado em cada servidor de Hyper-V Réplica que deseja receber a réplica.

# O comando New-VMReplicationAuthorizationEntry só pode ser executando quando o comando -ReplicationAllowedFromAnyServer estiver com o valor $false




## Liberação das portas do firewall dos servidores primário e réplica do Hyper-V Réplica. ##


Enable-NetfirewallRule -DisplayName "Ouvinte de HTTP da Réplica do Hyper-V (TCP-In)" # Português

Enable-NetFirewallRule -DisplayName "Ouvinte HTTPS da Réplica do Hyper-V (TCP-In)" # Português

Enable-NetfirewallRule -DisplayName "Hyper-V Replica HTTP Listener (TCP-In)" # Inglês

Enable-NetFirewallRule -DisplayName "Hyper-V Replica HTTPS Listener (TCP-In)" # Inglês


## Explicação do comando Enable-NetfirewallRule. ##



# Enable-NetfirewallRule - Este cmdlet permite que uma ou mais regras de firewall sejam habilitadas com o parâmetro Name (padrão), o parâmetro DisplayName, propriedades da regra ou por filtros ou objetos associados. O parâmetro Enabled para as regras consultadas resultantes é definido como True.


# -DisplayName - Especifica que apenas as regras de firewall correspondentes ao nome de exibição indicado estão habilitadas. Caracteres curinga são aceitos. Especifica o nome localizado e voltado para o usuário da regra de firewall que está sendo criada. Ao criar uma regra, este parâmetro é obrigatório. Este valor de parâmetro depende da localidade. Se o objeto não for modificado, o valor deste parâmetro poderá mudar em determinadas circunstâncias. Ao escrever scripts em ambientes multilíngues, o parâmetro Name deve ser usado, onde o valor padrão é um valor atribuído aleatoriamente. Este parâmetro não pode ser definido como Todos.



# Observação:

# Este comando deve ser executado em cada servidor de Hyper-V Réplica.




## Permitir a replicação de uma máquina virtual. ##


Enable-VMReplication -AuthenticationType Kerberos -ReplicaServerName HYRC.gabrielluiz.bh -ReplicaServerPort 80 -VMName VMTESTE -AutoResynchronizeEnabled $True -AutoResynchronizeIntervalEnd 23:59:59 -AutoResynchronizeIntervalStart 00:00:00 -CompressionEnabled $True -RecoveryHistory 8 -ReplicationFrequencySec 900


## Explicação do comando Enable-VMReplication. ##


# Enable-VMReplication - O cmdlet Enable-VMReplication permite a replicação de uma máquina virtual para um servidor de réplica especificado.

# -AuthenticationType - Especifica o tipo de autenticação a ser usado para replicação de máquina virtual, Kerberos ou Certificado. O servidor de réplica especificado deve oferecer suporte ao tipo de autenticação escolhido. Execute o cmdlet Get-VMReplicationServer para verificar a autenticação configurada para o servidor de réplica especificado ou entre em contato com o administrador do servidor de réplica especificado.

# -ReplicaServerName - Especifica o nome do servidor de réplica para o qual esta máquina virtual será replicada.

# -ReplicaServerPort - Especifica a porta no servidor de réplica a ser usada para tráfego de replicação. Certifique-se de especificar uma porta configurada no servidor de réplica para oferecer suporte ao mesmo tipo de autenticação especificado usando o parâmetro AuthenticationType neste cmdlet. Execute o cmdlet Get-VMReplicationServer no servidor de réplica para verificar a configuração da porta ou entre em contato com o administrador do servidor de réplica especificado.

# -VMName - Especifica qual máquina virtual deve receber a configuração da replicação definidar. Se caso quiser habilitar em todas as máquinas virtuais do host altere o valor para *.

# Este comando tem muitos parametros que podem ser modifcados de acordo com o seu cenário, temos alguns paramentros importantes são eles:

# -AutoResynchronizeEnabled - Sãos três modificações que podemos fazer, igualmenta a da GUI:

# Manual. -AutoResynchronizeEnabled 0 

# Automática. -AutoResynchronizeEnabled $True completa com os comandos: -AutoResynchronizeIntervalEnd 23:59:59 -AutoResynchronizeIntervalStart 00:00:00

# Agendada. -AutoResynchronizeEnabled $True completa com os comandos: -AutoResynchronizeIntervalEnd 18:00:00 -AutoResynchronizeIntervalStart 07:00:00

# -CompressionEnabled $True - HAbilita a compressão dos dados para trasmissão.

# -RecoveryHistory - Especifica se é necessário armazenar pontos de recuperação adicionais da máquina virtual. Armazenar mais do que o ponto de recuperação mais recente da máquina virtual, permite recuperar um ponto anterior no tempo. No entanto, armazenar pontos de recuperação adicionais requer mais espaço de armazenamento e processamento. Você pode configurar até 24 pontos de recuperação para serem armazenados.

# -ReplicationFrequencySec - Especifica a frequência, em segundos, na qual o servidor primário envia as alterações da máquina virtual para o servidor de réplica. Podemos colocar os seguinte valores 600 - para 5 minutos e 900 para 15 minutos, igualmente a GUI para replicação estendida.



# Observação:

# Este comando deve ser executado em cada servidor de Hyper-V Réplica Primário.




## Realizar a replicação inicial da máquina virtual. ##


Start-VMInitialReplication -VMName VMTESTE # Realizar a replicação inicial de uma máquina virtual especifica imediatamente.

Start-VMInitialReplication -VMName VMTESTE -InitialReplicationStartTime "06/04/2019 05:37 PM" # Realizar a replicação inicial da máquina virtual na data e hora especificado.

Start-VMInitialReplication * # Realizar a replicação inicial de todas as máquinas virtual do host de Hyper-V imediatamente.

Start-VMInitialReplication -VMName VMTESTE -DestinationPath D:\ # Neste exemplo as máquinas virtuais são exportadas para um HD externo e sua replicação inicial feita através.



## Explicação do comando Start-VMInitialReplication ###



# Start-VMInitialReplication - Inicia a replicação de uma máquina virtual.


# -VMName - Especifica o nome da máquina virtual na qual a replicação será iniciada.


# -InitialReplicationStartTime - Especifica a hora para iniciar a replicação inicial, ao planejar a replicação inicial para ocorrer mais tarde. Você pode especificar um prazo de até 7 dias depois. Quando este parâmetro não é especificado, a replicação inicial ocorre imediatamente.


# -DestinationPath D:\ - Especifica o caminho a ser utilizado ao copiar os arquivos para replicação inicial; assume o uso de mídia externa como método para replicação inicial. A mídia externa normalmente é uma unidade removível enviada para o local do servidor de réplica. Quando a mídia externa chegar ao site da réplica, use o cmdlet Import-InitialVMReplication na máquina virtual da réplica para copiar os arquivos.



# Observação:

# Os comandos apresentados acima devem ser executado no servidor primário.




## Realizar importação da replicação inicial. ##


Import-VMInitialReplication VM D:\VM_FC1E46AC-3F42-4256-BE1B-068A11FB35CB # Realizar importação da replicação inicial que estar armazenado no diretório d:\VM_FC1E46AC-3F42-4256-BE1B-068A11FB35CB.



## Explicação do comando Import-VMInitialReplication ###

# Import-VMInitialReplication - O cmdlet Import-VMInitialReplication importa arquivos da replicação inicial em um servidor de réplica. Ele conclui a replicação inicial de uma máquina virtual quando um HD externo é usado como a origem dos arquivos para a replicação inicial.




## Verifica informações da replicação estendida. ##


Measure-VMReplication –VMName VMTESTE -ReplicationRelationshipType Extended | select ***



## Explicação do comando Measure-VMReplication. ##



# Measure-VMReplication - O cmdlet Measure-VMReplication obtém estatísticas de replicação e informações associadas à máquina virtual. As estatísticas de replicação são calculadas por um período de tempo predeterminado com base no intervalo de monitoramento especificado por meio do cmdlet Set-VMReplicationServer.


# -VMName - Especifica o nome da máquina virtual para a qual você deseja obter estatísticas de replicação de máquina virtual.


# -ReplicationRelationshipType - Especifica o tipo de relacionamento de replicação da máquina virtual. Especifique se o relacionamento de replicação é primário simples (Simple) para replicação ou (Extended) é uma cadeia de replicação estendida . O cmdlet obtém estatísticas de replicação e informações associadas às máquinas virtuais que possuem o tipo de replicação especificado.





# Para cancelar a replicação execute o seguinte comando em ambos os servidor, primário e servidor réplica. 



Remove-VMReplication –VMName VMTESTE -ReplicationRelationshipType Extended # Este comando remove a replicação estendida da máquina virtual especificada.



## Explicação do comando Remove-VMReplication. ##



# Remove-VMReplication - Remove o relacionamento de replicação de uma máquina virtual.


# –VMName - Especifica o nome da máquina virtual da qual o relacionamento de replicação será removido.


# -ReplicationRelationshipType - Especifica o tipo de relacionamento de replicação da máquina virtual. Especifique se o relacionamento de replicação é primário simples (Simple) para replicação ou (Extended) é uma cadeia de replicação estendida . O cmdlet obtém estatísticas de replicação e informações associadas às máquinas virtuais que possuem o tipo de replicação especificado.




<#

Referências:


https://learn.microsoft.com/powershell/module/hyper-v/set-vmreplicationserver?view=windowsserver2022-ps&WT.mc_id=AZ-MVP-5003815

https://learn.microsoft.com/powershell/module/hyper-v/new-vmreplicationauthorizationentry?view=windowsserver2022-ps&WT.mc_id=AZ-MVP-5003815

https://learn.microsoft.com/powershell/module/netsecurity/enable-netfirewallrule?view=windowsserver2022-ps&WT.mc_id=AZ-MVP-5003815

https://learn.microsoft.com/powershell/module/hyper-v/enable-vmreplication?view=windowsserver2022-ps&WT.mc_id=AZ-MVP-5003815

https://learn.microsoft.com/powershell/module/hyper-v/start-vminitialreplication?view=windowsserver2022-ps&WT.mc_id=AZ-MVP-5003815

https://learn.microsoft.com/powershell/module/hyper-v/import-vminitialreplication?view=windowsserver2022-ps&WT.mc_id=AZ-MVP-5003815

https://learn.microsoft.com/powershell/module/hyper-v/measure-vmreplication?view=windowsserver2022-ps&WT.mc_id=AZ-MVP-5003815

https://learn.microsoft.com/powershell/module/hyper-v/remove-vmreplication?view=windowsserver2022-ps&WT.mc_id=AZ-MVP-5003815


#>
# Terraform AWS Labs

Repositório com laboratórios de infraestrutura AWS usando Terraform, organizados por módulo.

## Estrutura do projeto

- `ec2/`: EC2 Free Tier com acesso via SSM
- `rds/`: PostgreSQL RDS Free Tier
- `lambda/`: Lambda Python com IAM e CloudWatch Logs
- `bedrock/`: módulo mínimo para Bedrock Agent
- `local/`: laboratório local de apoio

Cada módulo segue o padrão:

- `providers.tf`: versão do Terraform/provider e provider AWS
- `variables.tf`: variáveis de entrada
- `datasources.tf`: blocos `data` para leitura de recursos existentes
- `main.tf`: recursos principais (`resource`)
- `outputs.tf` ou `output.tf`: saídas úteis
- `terraform.tfvars-modelo`: modelo de variáveis para uso local

## Pré-requisitos

- Terraform `>= 1.5.0`
- AWS CLI configurado (`aws configure`)
- Permissões IAM para cada módulo

## Fluxo padrão por módulo

Execute a partir da raiz do repositório:

```powershell
terraform -chdir=modules/<modulo> init
terraform -chdir=modules/<modulo> validate
terraform -chdir=modules/<modulo> plan
terraform -chdir=modules/<modulo> apply
```

Para destruir recursos:

```powershell
terraform -chdir=modules/<modulo> destroy
```

Exemplo para EC2:

```powershell
terraform -chdir=modules/ec2 init
terraform -chdir=modules/ec2 apply
```

## Variáveis e tfvars

- Arquivos `terraform.tfvars` ficam ignorados no Git por segurança
- Use `terraform.tfvars-modelo` como base para criar `terraform.tfvars` local

Exemplo:

```powershell
Copy-Item .\modules\ec2\terraform.tfvars-modelo .\modules\ec2\terraform.tfvars
```

## Módulos

### EC2

- Cria instância EC2 `t3.micro`
- Usa IAM Role + Instance Profile para acesso via Session Manager
- Não depende de SSH público

### RDS

- Cria PostgreSQL no Free Tier
- Configura DB Subnet Group e Security Group
- Exporta endpoint e porta via outputs

### Lambda

- Empacota código Python em `lambda/src`
- Cria função Lambda, role de execução e log group
- Mantém configuração otimizada para laboratório

### Bedrock

- Cria role IAM de execução para agente
- Cria `aws_bedrockagent_agent`
- Cria `aws_bedrockagent_agent_alias`

Observação de custo: Bedrock é pay-per-use. Não tratar como custo zero.

## Segurança

- Não versionar credenciais, senhas ou `terraform.tfvars`
- Manter `.gitignore` atualizado
- Preferir policies IAM de menor privilégio possível

## Comandos úteis

```powershell
terraform -chdir=modules/<modulo> output
terraform -chdir=modules/<modulo> state list
terraform -chdir=modules/<modulo> fmt
```


# Terraform AWS Labs

Repositório com laboratórios de infraestrutura AWS usando Terraform, organizado em módulos por produto e com um `main.tf` na raiz para orquestração opcional.

## Estrutura do projeto

```text
terraform-code/
	main.tf
	variables.tf
	terraform.tfvars-modelo
	policy-aws/
	modules/
		ec2/
		rds/
		lambda/
		bedrock/
		eks/
```

### Pasta raiz

- `main.tf`: módulo raiz que chama os módulos em `modules/`
- `variables.tf`: flags de deploy e variáveis centralizadas para o uso via raiz
- `terraform.tfvars-modelo`: modelo para uso do módulo raiz
- `policy-aws/`: policies IAM em JSON centralizadas para uso no console AWS

### Módulos em `modules/`

Cada módulo segue o padrão:

- `providers.tf`: versões mínimas do Terraform e providers requeridos
- `variables.tf`: variáveis de entrada
- `datasources.tf`: blocos `data` para leitura de recursos existentes
- `main.tf`: recursos principais
- `outputs.tf` ou `output.tf`: saídas úteis
- `terraform.tfvars-modelo`: modelo de variáveis para uso local

## Pré-requisitos

- Terraform `>= 1.5.0`
- AWS CLI configurado (`aws configure`)
- Permissões IAM para cada módulo

## Modos de uso

Existem duas formas de operar este repositório.

### 1. Uso direto por módulo

É a forma mais segura para laboratórios isolados, porque cada módulo mantém seu próprio estado.

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

### 2. Uso pela raiz com seleção por flags

O `main.tf` da raiz permite ativar módulos específicos via terminal.

Exemplos:

```powershell
# Subir só EC2
terraform apply -var="deploy_ec2=true"

# Subir só Lambda
terraform apply -var="deploy_lambda=true"

# Subir só RDS
terraform apply -var="deploy_rds=true" -var="rds_db_password=MinhaSenhaSegura"

# Subir só EKS
terraform apply -var="deploy_eks=true"
```

Flags disponíveis na raiz:

- `deploy_ec2`
- `deploy_rds`
- `deploy_lambda`
- `deploy_bedrock`
- `deploy_eks`

Observação importante:

- O uso pela raiz compartilha o mesmo state entre os módulos ativados.
- Se um módulo que já existe no state ficar com flag `false`, o Terraform pode planejar sua destruição.
- Para isolamento total, prefira `terraform -chdir=modules/<modulo> ...`

## Variáveis e tfvars

- Arquivos `terraform.tfvars` ficam ignorados no Git por segurança
- Use `terraform.tfvars-modelo` como base para criar `terraform.tfvars` local

Exemplo:

```powershell
Copy-Item .\modules\ec2\terraform.tfvars-modelo .\modules\ec2\terraform.tfvars
```

Para uso pela raiz:

```powershell
Copy-Item .\terraform.tfvars-modelo .\terraform.tfvars
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

- Empacota código Python em `modules/lambda/src`
- Cria função Lambda, role de execução e log group
- Mantém configuração otimizada para laboratório

### Bedrock

- Cria role IAM de execução para agente
- Cria `aws_bedrockagent_agent`
- Cria `aws_bedrockagent_agent_alias`

Observação de custo: Bedrock é pay-per-use. Não tratar como custo zero.

### EKS

- Cria cluster EKS com configuração mínima para laboratório
- Cria node group com suporte a `SPOT`
- Mantém guardrails simples de custo nas variáveis do módulo

## Policies IAM

As policies para uso no console AWS ficam centralizadas em `policy-aws/`.

Arquivos disponíveis:

- `policy-aws/ec2-iam-policy.json`
- `policy-aws/rds-iam-policy.json`
- `policy-aws/lambda-iam-policy.json`
- `policy-aws/bedrock-iam.json`
- `policy-aws/eks-iam-policy.json`

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


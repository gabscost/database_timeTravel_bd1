# database_timeTravel_bd1

# Banco de Dados de Viagem no Tempo  

Este projeto explora a criação de um banco de dados dedicado ao conceito fascinante e desafiador da **viagem no tempo**. Apesar da sua natureza ficcional e dos paradoxos inerentes, o objetivo é apresentar uma estrutura teórica simplificada para organizar e compartilhar informações relacionadas a esse tema.  

---

## 📝 **Objetivo**  
- Fornecer um modelo de banco de dados que permita consolidar informações sobre viagens no tempo.  
- Examinar os desafios e implicações envolvidos, como paradoxos temporais.  

---

## 📂 **Estrutura do Banco de Dados**  

O banco de dados possui as seguintes tabelas principais:  
1. **Viajantes**: Dados sobre os indivíduos que realizam as viagens.  
2. **Máquina do Tempo**: Informações sobre as máquinas utilizadas.  
3. **Fabricante**: Dados dos fabricantes das máquinas.  
4. **Destinos Temporais**: Locais e tempos visitados.  
5. **Viagens no Tempo**: Registro das viagens realizadas.  
6. **Eventos Temporais**: Eventos significativos no espaço-tempo.  
7. **Geração de Paradoxos**: Registro de paradoxos temporais criados.  
8. **Paradoxos**: Detalhes sobre os paradoxos registrados.  
9. **Missão**: Objetivos específicos das viagens.  
10. **Relatórios**: Documentação das missões realizadas.  
11. **Execução de Viagens**: Associação entre viagens e eventos.  
12. **Alteração no Espaço-Tempo**: Registros de eventos modificados.  

---

## 🔄 **Modelagem**  

- **Diagrama Entidade-Relacionamentos (ER):** Um diagrama ilustra as relações entre as tabelas.  
- O modelo organiza as informações relacionadas à viagem no tempo, incluindo viajantes, máquinas, destinos e eventos temporais.  

---

## 📊 **Consultas SQL**  

O projeto inclui diversas consultas para interagir com os dados. Aqui estão algumas:  

1. **Obter o nome do viajante e o modelo da máquina utilizada em cada viagem:**  
   ```sql
   SELECT v.nome, m.modelo
   FROM viajantes v
   JOIN viagens_tempo vt ON v.viajante_id = vt.viajante_idd
   JOIN maquina_tempo m ON vt.maquina_idd = m.maquina_id;
   ```  

2. **Listar todas as máquinas do tempo e eventos associados, mesmo que não haja associação:**  
   ```sql
   SELECT maquina_tempo.modelo, eventos_temporais.nome_evento
   FROM maquina_tempo
   LEFT JOIN executa_viagem ON maquina_tempo.maquina_id = executa_viagem.maquina_id
   LEFT JOIN eventos_temporais ON executa_viagem.evento_id = eventos_temporais.evento_id;
   ```  

3. **Consultar a média de idade dos viajantes, agrupada por sexo:**  
   ```sql
   SELECT sexo, AVG(idade) AS media_idade
   FROM viajantes
   GROUP BY sexo;
   ```  

4. **Contar a quantidade total de viagens feitas:**  
   ```sql
   SELECT COUNT(viagens_id)
   FROM viagens_tempo;
   ```  

Mais consultas podem ser encontradas no código-fonte!  

---

## 🛠️ **Tecnologias Utilizadas**  

- SQL (MySQL/PostgreSQL)  
- Ferramenta de modelagem de banco de dados para diagramas ER  

---

## 🤝 **Contribuições**  

Contribuições são bem-vindas! Caso tenha sugestões, dúvidas ou melhorias, sinta-se à vontade para abrir uma **issue** ou enviar um **pull request**.  

---

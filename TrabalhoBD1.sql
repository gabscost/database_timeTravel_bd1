DROP TABLE if exists viajantes CASCADE;
DROP TABLE IF EXISTS fabricante CASCADE;
DROP TABLE IF EXISTS maquina_tempo CASCADE;
DROP TABLE IF EXISTS viagens_tempo CASCADE;
DROP TABLE IF EXISTS eventos_temporais CASCADE;
DROP TABLE IF EXISTS destinos_temporais CASCADE;
DROP TABLE IF EXISTS paradoxos CASCADE;
DROP TABLE IF EXISTS gera CASCADE;
DROP TABLE IF EXISTS missao CASCADE;
DROP TABLE IF EXISTS relatorios CASCADE;
DROP TABLE IF EXISTS executa_viagem CASCADE;
DROP TABLE IF EXISTS alteracao CASCADE;
--tabela que registra cada viajante que pode ou não executar uma viagem
CREATE TABLE viajantes(
    viajante_id INT PRIMARY KEY,
    nome CHAR(30),
    idade INT,
    sexo CHAR(1) 
);
--tabela de quem são os fabricantes das maquinas do tempo utilizadas
CREATE TABLE fabricante(
    criador_id INT PRIMARY KEY,
    criador_nome CHAR(50) UNIQUE NOT NULL
);
--tabela que registramos as maquinas do tempo disponiveis para uso
CREATE TABLE maquina_tempo (
    maquina_id INT PRIMARY KEY,
    modelo CHAR(30) UNIQUE,
    capacidade_max INT,
    ano_criacao DATE,
    fabricante INT NOT NULL,
    CONSTRAINT fabricante_fk FOREIGN KEY (fabricante) REFERENCES fabricante(criador_id)
);
ALTER TABLE maquina_tempo
RENAME ano_criacao TO ano;
--trechos onde houve paradas:
CREATE TABLE destinos_temporais(
    destino_id INT PRIMARY KEY,
    nome_destino CHAR(70),
    descricao TEXT,
    periodo DATE ,
    localizacao CHAR(50)
);
--tabela que registramos quais viagens foram feitas
CREATE TABLE viagens_tempo (
    viagens_id INT PRIMARY KEY,
    viajante_idd INT,
    maquina_idd INT,
    destino_idd INT,
	data_partida DATE,
	data_chegada DATE,
    hora_saida TIME,
    hora_chegada TIME,
    CONSTRAINT viajante_fk FOREIGN KEY (viajante_idd) REFERENCES viajantes(viajante_id),
    CONSTRAINT maquina_fk  FOREIGN KEY (maquina_idd) REFERENCES maquina_tempo(maquina_id),
    CONSTRAINT destino_fk FOREIGN KEY (destino_idd) REFERENCES destinos_temporais(destino_id)
);
--eventos temporais que posteriormente serão catalizadores de paradoxos
CREATE TABLE eventos_temporais(
    evento_id INT PRIMARY KEY,
    nome_evento TEXT,
    descricao TEXT,
    hora_evento TIME,
    data_evento DATE,
    localizacao VARCHAR(50)
);
--tabela que indica qual evento foi alterado e por qual viajante, que assim gerou um paradoxo
CREATE TABLE gera(
	id_gerador INT PRIMARY KEY,
	viajante_id INT,
	evento_id INT,
	CONSTRAINT viajante_fk FOREIGN KEY(viajante_id)REFERENCES viajantes(viajante_id),
	CONSTRAINT evento_fk FOREIGN KEY(evento_id)REFERENCES eventos_temporais(evento_id)
);
--tabela de paradoxos, que são gerados por um viajante, evento e alteração
CREATE TABLE paradoxos(
	id_paradoxo INT PRIMARY KEY,
	descr_paradoxo TEXT,
	data_paradoxo DATE,
	hora_paradoxo TIME,
	gerador INT,
	CONSTRAINT gerador_fk FOREIGN KEY(gerador) REFERENCES gera(id_gerador)
);
--tabela constituida de missão, que são executadas em viagens, mas não necessariamente gera um paradoxo
CREATE TABLE missao(
	missao_id INT PRIMARY KEY,
	nome_missao VARCHAR(70),
	descr_missao TEXT,
	maquina_idd INT,
	viagem_idd INT,
	quem_fez INT,
	txt TEXT,
	CONSTRAINT quemfez_fk FOREIGN KEY(quem_fez) REFERENCES viajantes(viajante_id),
	CONSTRAINT maquina_fk FOREIGN KEY(maquina_idd) REFERENCES maquina_tempo(maquina_id),
	CONSTRAINT viagem_fk FOREIGN KEY(viagem_idd) REFERENCES viagens_tempo(viagens_id)
	
);
ALTER TABLE missao
DROP txt;
ALTER TABLE missao
RENAME quem_fez TO viajante_id;
--relatorios gerados após a execução de alguma missão
CREATE TABLE relatorios(
	relatorio_id INT,
	viajante_fez INT,
	missao_prod INT,
	txt TEXT,
	CONSTRAINT viajantef_fk FOREIGN KEY(viajante_fez) REFERENCES viajantes(viajante_id),
	CONSTRAINT missao_fk FOREIGN KEY(missao_prod) REFERENCES missao(missao_id)
);
ALTER TABLE relatorios
RENAME viajante_fez TO viajante;
--tabela para sabermos quem exucutou qual viagem, com qual maquina e qual evento foi afetado
CREATE TABLE executa_viagem(
	viajante_id INT,
	maquina_id INT,
	evento_id INT,
	PRIMARY KEY(viajante_id,maquina_id,evento_id),
	CONSTRAINT viajante_fk FOREIGN KEY(viajante_id) REFERENCES viajantes(viajante_id),
	CONSTRAINT maquina_fk FOREIGN KEY(maquina_id) REFERENCES maquina_tempo(maquina_id),
	CONSTRAINT ento_fk FOREIGN KEY (evento_id) REFERENCES eventos_temporais(evento_id)
);
--tabela que indica qual alteração foi feita, em qual evento, por qual viajante e assim se conectando ou não com algum paradoxo
CREATE TABLE alteracao(
	alteracao_id INT PRIMARY KEY,
	viajante_id INT,
	evento_id INT,
	txtalt TEXT,
	CONSTRAINT viajante_fk FOREIGN KEY (viajante_id) REFERENCES viajantes(viajante_id),
	CONSTRAINT evento_fk FOREIGN KEY (evento_id) REFERENCES eventos_temporais(evento_id)
);
--AREA DE PREENCHIMENTO DAS TABELAS
INSERT INTO viajantes VALUES (01,'Okabe Rintaro',40,'M'),
(02,'Sarah',36,'F'),(03,'Adam',42,'M'),(04,'Emmet',80,'M'),(05,'Looper',19,'F'),
(06,'Oraculo',49,'F'),(07,'McFly',29,'M'),
(08,'Neo',50,'M'),(09,'T-800',46,'F'),(10,'John titor',56,'M')
;
INSERT INTO fabricante VALUES (01,'Duolingo'),(02,'JohnDeLorean'),(03,'DoctorWho'),
(04,'CyberdyneSystems'),(05,'IBM'),(06,'Dark'),(07,'BlueOrige'),(08,'SpaceX'),
(09,'DrVegapunk'),(10,'Meta')
;

INSERT INTO maquina_tempo VALUES (001,'DeLorean',2,'1985/01/30',02),
(002,'Tardis',5,'3002/06/20',03),(003,'SkyNet',1,'2011/04/19',04),
(004,'Cronovisor',1,'1960/04/03',01),(005,'C204 Gravity Distortion',4,'2036/05/06',05),
(006,'WormHole',10,'2030/12/25',08),(007,'R2D2',1,'2080/04/01',07),(008,'C3PO',3,'2061/07/28',10),
(009,'TimeWarp',6,'3000/09/01',09),(010,'TimeSpiral',9,'2100/02/14',06)
;

DELETE FROM maquina_tempo WHERE maquina_id=008;
UPDATE maquina_tempo SET maquina_id=012 WHERE maquina_id=007;

INSERT INTO destinos_temporais VALUES 
(01,'Volta','Parado em Londres em 1920 para ver artes surrealistas','1920/04/20','Londres'),
(02,'Ida','Fomos no primeiro McDonalds criado','1955/04/15','Desplaines,Illinois,EUA'),
(03,'Passeio','Fui a um parque em Tokyo ver hologramas de árvores','2170/05/02','Ueno Park,Asakusa,Tokyo'),
(04,'Entretenimento antigo','Fui ao coliseu assistir uma luta ','0082/05/01','Roma,Italia'),
(05,'Rolê pela França','Paramos no castelo de Chenonceau','1456/07/12','França'),
(06,'Erro','Por um erro de digitação no ano paramos em uma civilização maia','0602/12/01','México'),
(07,'Domínio IA','Fomos parar em uma civilização dominada por IAs','2272/05/10','Night City,NEUA'),
(08,'Curiosidade Ida a Lua','Fomos ver a primeira vez que o homem pisou na lua','1969/07/20','LUA'),
(09,'Crucificao de cristo','fui ver a crucificacao de cristo?','0033/04/03','Calvario,Israel')
;

UPDATE destinos_temporais SET nome_destino='Erro bobo' WHERE nome_destino='Erro';

INSERT INTO viagens_tempo (viagens_id, viajante_idd, maquina_idd, destino_idd, data_partida, data_chegada, hora_saida, hora_chegada)
VALUES 
(1, 1, 1, 1, '1985/01/20', (SELECT periodo FROM destinos_temporais WHERE destino_id = 1), '08:00:00', '12:00:00'),
(2, 2, 2, 2, '2001/05/31', (SELECT periodo FROM destinos_temporais WHERE destino_id = 2), '10:00:00', '14:00:00'),
(3, 3, 3, 3, '2023/12/01', (SELECT periodo FROM destinos_temporais WHERE destino_id = 3), '12:00:00', '16:00:00'),
(4, 4, 4, 4, '1973/10/12', (SELECT periodo FROM destinos_temporais WHERE destino_id = 4), '14:00:00', '18:00:00'),
(5, 5, 5, 5, '2000/05/23', (SELECT periodo FROM destinos_temporais WHERE destino_id = 5), '16:00:00', '20:00:00'),
(6, 6, 6, 6, '2036/05/06', (SELECT periodo FROM destinos_temporais WHERE destino_id = 6), '18:00:00', '22:00:00');

INSERT INTO missao VALUES
(1,'Buscar conhecimento','Viajar para o futuro e coletar informações sobre avanços tecnológicos.',003,03,03),
(2,'Reliquia historica','Viajar para o passado e investigar a origem de uma relíquia histórica.',004,04,01),
(3,'Sobrevivencia','Sobrevivemos por um dia no Brasil em 602 d.C devido a um errro',006,6,6),
(4,'Informacoes sobre a Segunda guerra','viajar para a Segunda Guerra Mundial e coletar informações secretas sobre estratégias militares.',005,5,5),
(5,'4 minutos','Impedir o Brasil de perder a partida contra a Croacia(Copa do Mundo)',002,NULL ,08),
(6,'Impedir Criacao','Impedir criacao da maquina do tempo da IBM',006,6,6),
(7,'Situação','Ficar vivo até o final da viagem',012,5,7)
;

UPDATE missao SET nome_missao='Impedir a IBM' WHERE nome_missao='Impedir Criacao';

INSERT INTO relatorios (relatorio_id, viajante, missao_prod, txt)
VALUES
(1, 6, 3, 'Relatório Sobrevivencia, deu erro na Viagem e paramos no Brasil em 602 d.C.'),
(2, 6, 6, 'Relatório sobre a missão de Impedir criacao da Maquina da IBM.Paramos no Brasil.'),
(3, 3, 2, 'Relatório sobre a missão de viajar para a Idade Média e observar a vida cotidiana das pessoas.'),
(4, 5, 7, 'Relatório sobre situação da viagem no momento final da viagem.')
;

DELETE FROM relatorios WHERE relatorio_id=4;
DELETE FROM missao WHERE missao_id=7;
UPDATE relatorios SET txt='Relatório de sobrevivência, deu erro na Viagem e paramos no Brasil em 602 d.C.' WHERE txt='Relatório Sobrevivencia, deu erro na Viagem e paramos no Brasil em 602 d.C.';

INSERT INTO eventos_temporais (evento_id, nome_evento, descricao, hora_evento, data_evento, localizacao)
VALUES
(6, 'Primeiro Pouso na Lua', 'Marco na exploração espacial', '20:17:40', '1969-07-20', 'Mar da Tranquilidade, Lua'),
(11, 'Primeiro Voo dos Irmãos Wright', 'Primeiro voo bem-sucedido com uma aeronave mais pesada que o ar', '10:35:00', '1903-12-17', 'Kitty Hawk, Carolina do Norte, EUA'),
(10, 'Incidente de Roswell', 'Alegado acidente com uma nave extraterrestre em Roswell', '23:47:00', '1947-07-08', 'Roswell, Novo México, EUA'),
(3, 'Descoberta da Penicilina', 'Momento crucial na história da medicina', '09:00:00', '1928-09-03', 'Londres, Reino Unido'),
(9, 'Expedição de Magalhães', 'Primeira circum-navegação do globo terrestre por Fernão de Magalhães', '08:00:00', '1519-09-20', 'Sevilha, Espanha'),
(1, 'Concerto de Beethoven', 'Apresentação icônica de Beethoven', '20:00:00', '1805-12-22', 'Viena, Áustria');
INSERT INTO gera VALUES
(1,8,3),(3,4,6),(5,10,9);

INSERT INTO paradoxos (id_paradoxo,descr_paradoxo,data_paradoxo,hora_paradoxo,gerador)
VALUES 
(1,'Um viajante no tempo decide presenciar o primeiro pouso na Lua e, acidentalmente, deixa para trás um objeto tecnológico do futuro. Esse objeto é descoberto pelos astronautas e, quando levado de volta à Terra, desencadeia uma série de descobertas científicas e tecnológicas adiantadas, alterando significativamente a evolução tecnológica do planeta.','1969/07/20','20:18:40',3),
(2,'Um viajante no tempo, motivado pela descoberta da penicilina, decide entregar uma fórmula aprimorada do antibiótico aos cientistas do passado. Isso leva a uma mudança na cronologia médica, onde a penicilina é desenvolvida muito antes da sua descoberta original, afetando significativamente o curso da história da medicina.','1928-09-03','09:00:00',1),
(3,'Um viajante no tempo, durante a expedição de Magalhães, acidentalmente abre um portal interdimensional que conecta diferentes épocas e realidades. Isso resulta em uma mistura caótica de eventos históricos e pessoas de diferentes períodos temporais, criando uma realidade temporalmente instável e incoerente','1519-09-20','08:00:00',5)
;
--Apenas viajantes que concluiram misssões:
INSERT INTO executa_viagem (viajante_id,maquina_id,evento_id)
VALUES
(8,004,6),(4,001,3),(1,005,9);

INSERT INTO alteracao(alteracao_id,viajante_id,evento_id,txtalt)
VALUES
(1,06,10,'Impediu o governo americando de colher os destroços do caso Roswell'),
(2,07,11,'Atrapalhou o primeiro voo dos irmãos Wright'),
(3,02,1,'Filmou a apresentação de Bethoven');

--Consulta para obter o nome do viajante e o modelo da máquina do tempo utilizada em cada viagem:
SELECT v.nome, m.modelo
FROM viajantes v
JOIN viagens_tempo vt ON v.viajante_id = vt.viajante_idd
JOIN maquina_tempo m ON vt.maquina_idd = m.maquina_id;

--Consulta que retorna todas as máquinas do tempo e os eventos associados, mesmo que não haja eventos associados a alguma máquina:
SELECT maquina_tempo.modelo, eventos_temporais.nome_evento
FROM maquina_tempo
LEFT JOIN executa_viagem ON maquina_tempo.maquina_id = executa_viagem.maquina_id
LEFT JOIN eventos_temporais ON executa_viagem.evento_id = eventos_temporais.evento_id;

--Essa consulta retorna os IDs dos viajantes que fizeram viajens e missões:
SELECT viajante_idd FROM viagens_tempo
INTERSECT
SELECT viajante_id FROM missao;

--Essa consulta retorna os eventos que não estão na tabela de executa_viagem:
SELECT evento_id FROM eventos_temporais
EXCEPT
SELECT evento_id FROM executa_viagem;

--Essa consulta mostra os IDs dos eventos que foram alterados e não geraram paradoxos:
SELECT evento_id
FROM eventos_temporais
WHERE evento_id IN(
	SELECT evento_id
	FROM alteracao
);

--Essa consulta retorna tudo sobre os viajantes que fizeram ao menos uma viagem:
SELECT *
FROM viajantes
WHERE EXISTS(
	SELECT *
	FROM viagens_tempo
	WHERE viajante_id=viajante_idd
);

--Consulta que mostra  os destinos temporais e viagens associadas, mesmo que não haja viagens para um destino:
SELECT destinos_temporais.nome_destino, viagens_tempo.viagens_id
FROM destinos_temporais
LEFT JOIN viagens_tempo ON destinos_temporais.destino_id = viagens_tempo.destino_idd;

--Consulta que calcula a media da idade dos viajantes agrupadas por sexo:
SELECT sexo, AVG(idade) AS media_idade
FROM viajantes
GROUP BY sexo;

--Consulta que mostra a quantidade de missões realizadas por cada viajante:
SELECT v.viajante_id, v.nome, COUNT(*) 
FROM viajantes AS v
JOIN missao AS  m ON v.viajante_id = m.viajante_id
GROUP BY v.viajante_id, v.nome;

--Consulta que retorna todas as missões que possuem relatórios feitos:
SELECT *
FROM missao
WHERE EXISTS(
	SELECT *
	FROM relatorios
	WHERE missao_id=missao_prod
);

--Consulta que mostra a quantidade total de viagens feitas:
SELECT COUNT(viagens_id) 
FROM viagens_tempo;

--Consulta     que mostra os destinos visitados no futuro:
SELECT descricao,periodo
FROM destinos_temporais
WHERE periodo >='2024/01/01';

--Consulta que mostra os destinos visitados no passado:
SELECT descricao,periodo
FROM destinos_temporais
WHERE periodo <='2023/01/01';


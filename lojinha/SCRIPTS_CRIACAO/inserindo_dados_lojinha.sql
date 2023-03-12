
insert into categorias (descricao) values 
				('JOGOS'),('ELETRÔNICOS'),('SOM'),('ELETRODOMÉSTICOS');


SELECT * FROM CATEGORIAS;


INSERT INTO FABRICANTES (NOME_FABRICANTE) VALUES 
              ('FABR JOGOS'),('FABR ELETR.'),('FABR. SOM'),('FABR ELE.DOMES');
              

SELECT * FROM FABRICANTES;


insert into unidade_federal(cod_uf,uf,nome_uf)
select * from uf;


select * from unidade_federal;


insert into cidades (nome_cidade,cod_mun,cod_uf)
SELECT a.NOME_MUN,a.COD_MUN,a.cod_uf FROM SENSO a
WHERE ANO='2014';


SELECT * FROM CIDADES;



/* inserindo clientes*/

set @ano:=10;
set @data_cad=120;
 INSERT INTO CLIENTES (NOME,SOBRENOME,EMAIL,SENHA,Data_nasc,data_cadastro,situacao)
 SELECT A.FIRST_NAME,A.LAST_NAME,
       lower(concat(A.FIRST_NAME,a.LAST_NAME,'@meuemail.com'))email,
       md5(A.FIRST_NAME)as senha,
       DATE_ADD(a.LAST_UPDATE, INTERVAL -@ano:=@ano+1 year) data_nasc,
       DATE_ADD(a.LAST_UPDATE, INTERVAL +@data_cad:=@data_cad+1 month) data_cad,
       'A' situacao
 FROM ACTOR A
 limit 20;

-- verificando dados
select * from clientes;

-- inserindo dados de endereços
insert into cliente_endereco (id_cliente,tipo,endereco,numero,bairro,cep,id_cidade)
values
(1,'P','RUA A','123','Da luz','00000000','7'),
(2,'P','RUA B','321','Barreiro','00000000','15'),
(3,'P','RUA C','456','Sete Legas','00000000','20'),
(4,'P','RUA D','845','Engenheiros','00000000','30'),
(5,'P','RUA E','989','Santo Antonio','00000000','45'),
(6,'P','RUA F','155','Santa Luzia','00000000','200'),
(7,'P','RUA G','352','Querencia','00000000','1522'),
(8,'P','RUA H','158','Morada Nova','00000000','3500'),
(9,'P','RUA I','998','Cravos','00000000','4500'),
(10,'P','RUA J','453','Flores','00000000','5000'),
(11,'P','RUA K','23','Monte Alto','00000000','3575'),
(12,'P','RUA L','77','Ponte Torta','00000000','5121'),
(13,'P','RUA M','25','Novo Horizento','00000000','5212'),
(14,'P','RUA N','95','Nova Vida','00000000','689'),
(15,'P','RUA O','658','Engenho seco','00000000','211'),
(16,'P','RUA P','963','Engenho Doce','00000000','3304'),
(17,'P','RUA Q','147','Pico Malta','00000000','2704'),
(18,'P','RUA R','159','Floresta','00000000','3301'),
(19,'P','RUA S','951','Alvorada','00000000','2408'),
(20,'P','RUA T','753','Sol Nascente','00000000','5002');

-- verificando dados
select * from cliente_endereco;

-- dadps condicao e pgto

describe cond_pgto;

insert into cond_pgto (descricao,tipo) values ('A vista','B');
insert into cond_pgto (descricao,tipo) values ('A vista','D');
insert into cond_pgto (descricao,tipo) values ('10 X','C');
insert into cond_pgto (descricao,tipo) values ('5 X','C');
insert into cond_pgto (descricao,tipo) values ('3 X','C');

-- verificando dados
 select * from cond_pgto
 order by id_pgto;

-- estrutura tabela tabela
describe cond_pgto_det;
-- dados detalhe pgto

-- condicao 1
insert into cond_pgto_det values (1,1,100,1);

-- condicao 2 
insert into cond_pgto_det values (2,1,100,1);

-- condicao 3
insert into cond_pgto_det values (3,1,10,30);
insert into cond_pgto_det values (3,2,10,60);
insert into cond_pgto_det values (3,3,10,90);
insert into cond_pgto_det values (3,4,10,120);
insert into cond_pgto_det values (3,5,10,150);
insert into cond_pgto_det values (3,6,10,180);
insert into cond_pgto_det values (3,7,10,210);
insert into cond_pgto_det values (3,8,10,240);
insert into cond_pgto_det values (3,9,10,270);
insert into cond_pgto_det values (3,10,10,300);

-- condicao 4
insert into cond_pgto_det values (4,1,20,30);
insert into cond_pgto_det values (4,2,20,60);
insert into cond_pgto_det values (4,3,20,90);
insert into cond_pgto_det values (4,4,20,120);
insert into cond_pgto_det values (4,5,20,150);

-- condicao 5
insert into cond_pgto_det values (5,1,33.33,30);
insert into cond_pgto_det values (5,2,33.33,60);
insert into cond_pgto_det values (5,3,33.34,90);


-- verificando dados

select * from cond_pgto_det;

select a.id_pgto,a.descricao,a.tipo,
 case when a.tipo='B' then 'Boleto'
      when a.tipo='D' then 'Debito' 
      when a.tipo='C' then 'Cartao Credito' end tipo_pgto,  
 b.parcela,b.percentual,b.dias
from cond_pgto a
  inner join cond_pgto_det b
  on a.id_pgto=b.id_pgto

-- dados de produtos
describe produto;

insert into produto (descricao,id_categoria,id_fabricante,preco_custo,preco_venda)
values
('Jogo Infantil',1,1,50,200),
('Jogo Acao',1,1,50,200),
('Jogo Estrategia',1,1,50,200);

insert into produto (descricao,id_categoria,id_fabricante,preco_custo,preco_venda)
values
('Smart Tv 42',2,2,1300,2000),
('Notebook 15',2,2,2200,3000),
('SmartPhone',2,2,550,1200);

insert into produto (descricao,id_categoria,id_fabricante,preco_custo,preco_venda)
values
('Caixa de Som BOOM',3,3,750,1500),
('Som automotivo',3,3,250,500),
('Sound MIX',3,3,750,1200);

insert into produto (descricao,id_categoria,id_fabricante,preco_custo,preco_venda)
values
('Geladeira',4,4,780,1580),
('Batedeira',4,4,200,450),
('Aspirador de Pó',4,4,200,4500);

-- verificando dados
select * from produto;


-- verificando cadastrdos
select a.id_produto,a.descricao,a.preco_custo,a.preco_venda,
  b.nome_fabricante,c.descricao categoria
from
produto a
inner join fabricantes b
on a.id_fabricante=b.id_fabricante
inner join categorias c
on a.id_categoria=c.id_categoria;

-- inserindo dados estoque


insert into estoque (id_produto,estoque_total,estoque_livre,estoque_reservado) values
				    ('1','100','100','0'),('2','100','100','0'),('3','100','100','0'),
                ('4','100','100','0'),('5','100','100','0'),('6','100','100','0'),
                ('7','100','100','0'),('8','100','100','0'),('9','100','100','0'),
                ('10','100','100','0'),('11','100','100','0'),('12','100','100','0');
                
--  verificando produtos estoque
select a.id_produto,a.descricao,a.preco_custo,a.preco_venda,
  b.nome_fabricante,c.descricao categoria,
  d.estoque_total as est_tot,d.estoque_livre as est_livre,d.estoque_reservado as est_reser
from
produto a
inner join fabricantes b
on a.id_fabricante=b.id_fabricante
inner join categorias c
on a.id_categoria=c.id_categoria
inner join estoque d
on a.id_produto=d.id_produto;
 




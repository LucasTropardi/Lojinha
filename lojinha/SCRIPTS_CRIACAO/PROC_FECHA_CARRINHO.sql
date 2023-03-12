
-- fecha o carriho, gera pedido
DELIMITER //
create procedure proc_fecha_carrinho (v_sessao varchar(32),
                                      v_id_cliente int,
                                      v_id_pagto int,
                                      v_frete decimal(10,2), 
                                      v_ender char(1), -- P principal -- A alternativo
                                      OUT resposta VARCHAR(255))
main: begin
        DECLARE v_total_ped decimal(10,2);
        DECLARE v_total_desc decimal(10,2);
		  DECLARE v_num_ped int;
        DECLARE v_id_endereco int;
        DECLARE cod_erro CHAR(5) DEFAULT '00000';
	     DECLARE msg TEXT;
	     DECLARE raws INT;
	     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    	BEGIN
		GET DIAGNOSTICS CONDITION 1
	      cod_erro = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
		END;
		
    
    -- Peganto tatol carrinho atribuindo a variavel
    select sum(total)as tot,sum(desconto) as descto into v_total_ped,v_total_desc
    from carrinho_compras
    where sessao=MD5(v_sessao);
    
    
    -- pegando emdereço cliente
    select id_endereco into v_id_endereco from cliente_endereco
    where id_cliente=v_id_cliente limit 1;
    -- carga no carrinho de compras
    -- inicia transacao
    START TRANSACTION;
    
     insert into pedidos 
     (id_cliente,id_endereco,id_pagto,total_prod,
                         total_frete,total_desc,total_pedido,data_pedido,status_ped)
				values 
      (v_id_cliente,v_id_endereco,v_id_pagto,v_total_ped,v_frete,v_total_desc,
              ((v_total_ped+v_frete)-v_total_desc),now(),'A');
              
	  -- pegando id do pedido
      set v_num_ped=LAST_INSERT_ID();
      -- inserindo pedido itens
      insert into pedido_itens
      (num_pedido,id_produto,qtd,val_unit,desconto,total)
      select v_num_ped,id_produto,qtd,val_unit,desconto,total
      from carrinho_compras
      where sessao=MD5(v_sessao);
      -- eliminando itens do carrinho
      delete from carrinho_compras
      where sessao=MD5(v_sessao);  

-- checando excessao com IF

 IF cod_erro = '00000' THEN
    	  GET DIAGNOSTICS raws = ROW_COUNT;
		  SET resposta = CONCAT('Atualizacao com Sucesso  = ',raws);
          commit;
	ELSE
		SET resposta = CONCAT('Erro na atualizacao, error = ',raws,cod_erro,', message = ',msg);
        rollback;
  END IF;
  /*
  select concat('resposta ',resposta)
  union all
  SELECT concat('cod_erro ',cod_erro)
  union all
  SELECT concat('v_total_ped ',v_total_ped) 
  union all
  SELECT concat('v_total_desc ',v_total_desc)
  union all
  SELECT concat('v_num_ped ',v_num_ped)
  union all
  SELECT concat('v_id_endereco ',v_id_endereco);
*/	
END//
DELIMITER ;


-- variaveis da procedure
-- v_sessao varchar(32),
-- v_id_cliente int,
-- v_id_pagto int,
-- v_frete decimal(10,2), 
-- v_ender char(1), -- P principal -- A alternativo
-- OUT resposta VARCHAR(50))
call proc_fecha_carrinho(1,1,3,9.00,'P',@resposta);
select @resposta;


call proc_fecha_carrinho(2,1,2,15.00,'P',@resposta);
select @resposta;
select * from carrinho_compras;

select * from carrinho_compras;
select * from estoque;
select * from pedidos;
select * from pedido_itens;
select * from rastreabilidade;
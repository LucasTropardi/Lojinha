-- drop procedure proc_carga_carrinho
DELIMITER //
create procedure proc_carga_carrinho (v_sessao varchar(32),
                                      v_id_prod int,
                                      v_qtde int,
                                      OUT resposta VARCHAR(50))
main: begin
        DECLARE v_qtde_livre int;
        DECLARE v_preco_venda decimal(10,2);
        DECLARE cod_erro CHAR(5) DEFAULT '00000';
	     DECLARE msg TEXT;
	     DECLARE raws INT;
	     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    	BEGIN
	      GET DIAGNOSTICS CONDITION 1
	      cod_erro = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
      END;
		
    
    -- Lendo qtde no estoque e atribuindo a variavel
    select estoque_Livre into v_qtde_livre from estoque
    where id_produto=v_id_prod;
    
    select v_qtde_livre;
    -- verificando se existe saldo disponivel
    IF v_qtde>v_qtde_livre then
    	SET resposta='Quantidade Indisponivel';
    LEAVE main;
	END IF;
    
    -- pegando preco de venda
    select preco_venda into v_preco_venda from produto
    where id_produto=v_id_prod;
    -- carga no carrinho de compras
    -- inicia transacao
    START TRANSACTION;
    -- carregando carrinhos
    insert into carrinho_compras values 
      (md5(v_sessao),v_id_prod,v_qtde,v_preco_venda,0,v_qtde*v_preco_venda,now());
	
    -- atualizando disponibilidade estoque
   update estoque set estoque_livre=estoque_livre-v_qtde,
                      estoque_reservado=estoque_reservado+v_qtde
	where id_produto=v_id_prod;
    
-- checando excessao com IF

 IF cod_erro = '00000' THEN
    	  GET DIAGNOSTICS raws = ROW_COUNT;
		  SET resposta = CONCAT('Atualizacao com Sucesso  = ',raws);
          commit;
	ELSE
		SET resposta = CONCAT('Erro na atualizacao, error = ',cod_erro,', message = ',msg);
        rollback;
  END IF;
	
END//
DELIMITER ;

-- paramentros
-- v_sessao varchar(32),
-- v_id_prod int,
-- v_qtde int,
-- OUT resposta VARCHAR(50))

call proc_carga_carrinho(2,6,3,@resposta);
select @resposta;

select * from carrinho_compras;
select * from estoque;



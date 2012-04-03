#coding:utf-8

require 'unicode'

module ReferenciaBibliografica
  def referencia_abnt
    gerar
  end

  private

  def referencia_objetos_de_aprendizagem
    "#{autores_abnt} #{titulo}. #{instituicao}."
  end

  def referencia_imagem
    "#{autores_abnt} #{titulo}. #{instituicao}, #{local}."
  end

  def referencia_relatorio_tecnico_cientifico
    "#{autores_abnt} #{titulo}. #{local_publicacao}: #{instituicao}, "\
    "#{ano_publicacao}. #{numero_paginas} p."
  end

  def referencia_livro
    "#{autores_abnt} #{titulo}: #{gerar_subtitulo}. #{traducao}#{edicao}" \
    "#{local_publicacao}: #{editora}, #{ano_publicacao}. #{numero_paginas} p."
  end

  def referencia_periodico_tecnico_cientifico
    "#{titulo}. #{local_publicacao}: #{editora}, " \
    "#{ano_primeiro_volume}-#{ano_ultimo_volume}"
  end

  def referencia_artigo_periodico
    "#{autores_abnt} #{titulo}#{gerar_subtitulo}. #{nome_periodico}, "\
    "#{local_publicacao}, v. #{volume}, n. #{fasciculo}, "\
    "p. #{pagina_inicial}-#{pagina_final}, #{data_publicacao}."
  end

  def referencia_artigo_anais_evento
    "#{autores_abnt} #{titulo}.#{gerar_subtitulo} In: #{nome_evento}, " \
    "#{numero_evento}., #{ano_evento}, #{local_evento}. " \
    "#{titulo_anais}. #{local_publicacao}: #{editora}, " \
    "#{ano_publicacao}. P. #{pagina_inicial}-#{pagina_final}."
  end

  def referencia_outros_conteudos
    "#{autores_abnt} #{titulo}. #{instituicao}."
  end

  def gerar_subtitulo
    subtitulo || ''
  end

  def autores_abnt
    lista_autores = autores.split(';')
    lista_autores.each_index do |i|
      nome_autor = lista_autores[i].split(' ')
      nome_autor.delete('') if nome_autor.include? ('')
      nome_abnt = Unicode.upcase nome_autor.pop + ','
      nome_autor.each_index do |j|
        nome_abnt += ' ' + nome_autor[j][0] + '.'
      end
      lista_autores[i] = nome_abnt
    end
    lista_autores * "; "
  end

  def referencia_trabalho_conclusao
    "#{autores_abnt} #{titulo}#{gerar_subtitulo}. #{data_defesa}. "\
    "#{total_folhas} f. #{tipo_trabalho} - #{instituicao}, #{local_defesa}."
  end

  def gerar
    conversores = {
      'trabalho de conclusão'        => :referencia_trabalho_conclusao,
      'artigo de anais de eventos'   => :referencia_artigo_anais_evento,
      'artigo de periodico'          => :referencia_artigo_periodico,
      'periodico tecnico cientifico' => :referencia_periodico_tecnico_cientifico,
      'livro'                        => :referencia_livro,
      'relatorio tecnico cientifico' => :referencia_relatorio_tecnico_cientifico,
      'imagem'                       => :referencia_imagem,
      'objetos de aprendizagem'      => :referencia_objetos_de_aprendizagem,
      'outros conteúdos'             => :referencia_outros_conteudos }
    __send__(conversores[self.tipo])
  end
end

import java.util.ArrayList;
import java.util.Collections;

// ================== VARIÁVEIS GLOBAIS ==================
String nomeJogador = ""; // Nome do jogador
boolean esperandoNome = true; // Se true, aguarda o jogador digitar o nome

int estado = 0; // Controla a tela atual do jogo: 0 = Menu, 1 = Jogo, 2 = Como Jogar, 3 = Sair
int indiceHistoria = 0; // Índice da história para exibição
String[] historia; // Array que contém os textos da história

int posicaoMarciano;  // Número da árvore onde o Marciano está escondido
int tentativasRestantes = 10;  // Tentativas disponíveis antes do Marciano mudar de posição
boolean jogoAtivo = true;  // Indica se o jogo está em andamento

String tentativaTexto = "";  // Entrada do jogador antes de confirmar com ENTER
String mensagem = ""; // Mensagem exibida na interface do jogo
boolean fimDeJogo = false; // Indica se o jogo terminou (venceu ou perdeu)

int tempoInicio; // Registra o tempo de início do jogo para cálculo de recordes
int tempoSaida = 0; // Registra o tempo de saída para criar um efeito de despedida antes de fechar o jogo

// ================== CONFIGURAÇÃO INICIAL ==================
void setup() {
  size(500, 500);
  background(0);
}

void draw() {
  background(0);

  if (estado == 0) {
    menuInicial();
  } else if (estado == 1) {
    jogo();
  } else if (estado == 2) {
    tabelaDeRecordes();
  } else if (estado == 3) {
    iniciarPartida();
  } else if (estado == 4) {
    sair();
  }

  // Exibir a mensagem em qualquer estado
  fill(255, 255, 0);
  textSize(18);
  textAlign(CENTER, CENTER);
  text(mensagem, width / 2, height - 40);
}

// ================== CLASSE DE RECORDES ==================
class Recorde {
  String nome;
  int tempo;

  Recorde(String nome, int tempo) {
    this.nome = nome;
    this.tempo = tempo;
  }
}

ArrayList<Recorde> recordes = new ArrayList<Recorde>();

// ================== MENU INICIAL ==================
void menuInicial() {
  
  mensagem = ""; // Limpa qualquer mensagem anterior ao exibir o menu
  
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  
  text("JOGO DO MARCIANO", width / 2, height / 3);
  
  textSize(20);
  text("INICIAR", width / 2, height / 2 - 30);
  text("TABELA DE RECORDES", width / 2, height / 2);
  text("SAIR", width / 2, height / 2 + 30);
}

// ----- CONTROLE DO MOUSE -----
void mousePressed() {
  if (estado == 0) { // Se estiver no menu inicial
    float centroX = width / 2;
    float larguraBotao = 150;
    float alturaBotao = 30;

    // Verifica se o clique foi na opção "INICIAR"
    if (mouseX > centroX - larguraBotao / 2 && mouseX < centroX + larguraBotao / 2 &&
        mouseY > height / 2 - 40 && mouseY < height / 2 - 10) {
      estado = 1; // Ir para a tela de jogo
    }
    // Verifica se o clique foi na opção "TABELA DE RECORDES"
    else if (mouseX > centroX - larguraBotao / 2 && mouseX < centroX + larguraBotao / 2 &&
             mouseY > height / 2 - 10 && mouseY < height / 2 + 20) {
      estado = 2; // Ir para a Tabela de Recordes
    }
    // Verifica se o clique foi na opção "SAIR"
    else if (mouseX > centroX - larguraBotao / 2 && mouseX < centroX + larguraBotao / 2 &&
             mouseY > height / 2 + 20 && mouseY < height / 2 + 50) {
      estado = 4; // Agora o estado 4 é para sair
    }
  }
}

// ----- EXIBIR HISTÓRIA -----
void contarHistoria() {
  background(0);
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  
  float larguraTexto = 400; // Define a largura máxima do texto
  float alturaTexto = 200;  // Define a altura máxima do bloco de texto
  
  // Exibe a parte da história atual, garantindo que o texto quebre corretamente
  text(historia[indiceHistoria], width / 2 - larguraTexto / 2, height / 2 - 50, larguraTexto, alturaTexto);

  // Mensagem para o jogador saber como avançar
  textSize(16);
  text("Pressione ENTER ou clique para continuar...", width / 2, height - 50);
}

// ----- HISTÓRIA E JOGO -----
void gerarHistoria() {
  historia = new String[] {
    "Bem-vindo, " + nomeJogador + "!",
    "Em um planeta distante chamado Xylox, um pequeno marciano chamado Zorp se perdeu enquanto explorava a Floresta das Mil Árvores.",
    "Ele adora brincar de esconde-esconde, mas dessa vez foi longe demais e agora ninguém consegue encontrá-lo!",
    "Você, " + nomeJogador + ", é um explorador intergaláctico e recebeu uma missão muito importante: encontrar Zorp antes que a noite caia.",
    "A única pista que você tem é que Zorp está escondido em uma árvore numerada de 1 a 100.",
    "Seu comunicador intergaláctico consegue detectar a posição aproximada de Zorp e te dirá se ele está em uma árvore maior ou menor do que a escolhida.",
    "Será que você consegue encontrar o pequeno marciano antes que ele se assuste? Boa sorte, explorador! 🚀👽"
  };
}

// ----- SOLICITAR NOME DO JOGADOR -----
void pedirNome() {
  background(0);
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  
  // Exibir a mensagem para o jogador digitar o nome
  text("Digite seu nome:", width / 2, height / 3);
  
  textSize(20);
  // Exibir o nome digitado até o momento, com um "_" no final para indicar que está aguardando entrada
  text(nomeJogador + "_", width / 2, height / 2);
}


// ----- GERENCIAR INÍCIO DO JOGO -----
void jogo() {
  if (esperandoNome) {
    // Exibe a tela para o jogador digitar seu nome
    pedirNome();
  } else {
    // Inicia a história do jogo
    contarHistoria();
  }
}

// ----- INICIAR UMA NOVA PARTIDA -----
void iniciarJogo() {
  estado = 3;  // Define o estado do jogo ativo
  posicaoMarciano = int(random(1, 101)); // Gera um número aleatório entre 1 e 100
  tentativasRestantes = 10; // Reinicia o número de tentativas
  jogoAtivo = true; // Ativa o jogo
  mensagem = "O jogo começou! O Marciano está escondido. Adivinhe de 1 a 100.";
  tempoInicio = millis(); // Registra o tempo inicial da partida
}

// ----- VERIFICAR TENTATIVA DO JOGADOR -----
void verificarTentativa(int tentativa) {
    if (tentativa == posicaoMarciano) {
        // Calcula o tempo total gasto na partida
        int tempoFinal = millis();
        int tempoTotal = (tempoFinal - tempoInicio) / 1000;
        
        String mensagemRecorde = "";

        if (!recordes.isEmpty()) {
            // Obtém o melhor tempo atual
            Recorde melhorRecorde = recordes.get(0);
            for (Recorde r : recordes) {
                if (r.tempo < melhorRecorde.tempo) {
                    melhorRecorde = r;
                }
            }

            // Se o novo tempo for menor, temos um novo recorde!
            if (tempoTotal < melhorRecorde.tempo) {
                mensagemRecorde = "Novo recorde! Você ultrapassou " + melhorRecorde.nome + "!";
            }
        } else {
            mensagemRecorde = "Primeiro recorde registrado!";
        }

        // Mensagem de vitória
        mensagem = "Parabéns, " + nomeJogador + "! Você encontrou o Marciano! 🎉\n" + mensagemRecorde;
        
        // Finaliza o jogo
        jogoAtivo = false;
        fimDeJogo = true;

        // Adiciona o novo recorde à lista
        recordes.add(new Recorde(nomeJogador, tempoTotal));
    } else {
        // Diminui tentativas restantes
        tentativasRestantes--;

        // Dica se a posição é maior ou menor
        if (tentativa < posicaoMarciano) {
            mensagem = "O Marciano está em uma árvore MAIOR!";
        } else {
            mensagem = "O Marciano está em uma árvore MENOR!";
        }

        // Se acabar as tentativas, o Marciano muda de posição
        if (tentativasRestantes == 0) {
            mensagem = "Você perdeu! O Marciano mudou de lugar... 😢";
            posicaoMarciano = int(random(1, 101)); 
            tentativasRestantes = 10;
        }
    }
}

// ----- INTERFACE DA PARTIDA -----
void iniciarPartida() {
  background(0);
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);

  if (jogoAtivo) {
    // Exibe informações do jogo enquanto ele está em andamento
    text("Tente encontrar o Marciano!", width / 2, height / 4);
    text("Digite um número entre 1 e 100", width / 2, height / 3);
    text("Tentativas restantes: " + tentativasRestantes, width / 2, height / 2);
    text("Seu palpite: " + tentativaTexto + "_", width / 2, height / 2 + 50);
  } else {
    // Se o jogo terminou, exibe a mensagem de fim
    textSize(20);
    String mensagemFim = "Fim de Jogo! Pressione ENTER para voltar ao menu.";

    // Se a mensagem for longa, divide em duas linhas para melhor exibição
    if (mensagemFim.length() > 40) {
      String parte1 = mensagemFim.substring(0, 40);
      String parte2 = mensagemFim.substring(40);
      text(parte1, width / 2, height / 2);
      text(parte2, width / 2, height / 2 + 30);
    } else {
      text(mensagemFim, width / 2, height / 2);
    }
  }

  // **Exibir a mensagem dinâmica do jogo na parte inferior da tela**
  textSize(18);
  text(mensagem, width / 2, height - 40);  // Ajustado para evitar que saia da tela
}


// ----- TABELA DE RECORDES -----
void tabelaDeRecordes() {
  background(0, 0, 150); // Define a cor do fundo
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Tabela de Recordes", width / 2, 50); 

  // Ordenar a lista de recordes (menor tempo primeiro)
  Collections.sort(recordes, (a, b) -> a.tempo - b.tempo);

  textSize(20);
  int y = 100; // Posição inicial dos nomes na tela

  // Exibir os 5 melhores recordes
  for (int i = 0; i < min(5, recordes.size()); i++) {
    Recorde r = recordes.get(i);
    text((i + 1) + ". " + r.nome + " - " + r.tempo + "s", width / 2, y);
    y += 30; // Ajusta a posição para a próxima linha
  }

  // Exibir a mensagem para retornar ao menu
  textSize(16);
  text("Pressione ENTER para voltar ao menu", width / 2, height - 50);
}

// ----- SAIR DO JOGO -----
void sair() {
  // Define o tempo de saída na primeira execução
  if (tempoSaida == 0) {
    tempoSaida = millis(); // Guarda o tempo atual quando a função for chamada
  }

  // Exibir tela de despedida
  background(0);
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Até um outro Dia!", width / 2, height / 3);

  // Aguarda 2 segundos antes de fechar o jogo
  if (millis() - tempoSaida > 2000) {
    exit(); // Fecha o programa
  }
}

// ----- CAPTURA DE TECLAS -----
void keyPressed() {
  // Se o jogo terminou e ENTER for pressionado, volta ao menu principal
  if (fimDeJogo) { 
    if (key == ENTER) {
      estado = 0;  // Retorna ao menu inicial
      fimDeJogo = false; // Reseta o estado de fim de jogo
      mensagem = ""; // Limpa a mensagem ao voltar ao menu
      
      // Resetar nome para permitir um novo jogador
      nomeJogador = ""; 
      esperandoNome = true;
        
      // Resetar o índice da história
      indiceHistoria = 0;
    }
    return; // Impede que o resto do código continue
  }

  // Entrada do nome e exibição da história
  if (estado == 1) {
    if (esperandoNome) {
      // Se BACKSPACE for pressionado, apaga o último caractere do nome
      if (key == BACKSPACE && nomeJogador.length() > 0) {
        nomeJogador = nomeJogador.substring(0, nomeJogador.length() - 1);
      } 
      // Se ENTER for pressionado e o nome não estiver vazio, inicia a história
      else if (key == ENTER && nomeJogador.length() > 0) {
        esperandoNome = false;
        gerarHistoria();
      } 
      // Adiciona letras ao nome (limite de 10 caracteres)
      else if (key != BACKSPACE && key != ENTER && nomeJogador.length() < 10) {
        nomeJogador += key;
      }
    } 
    // Avança na história com ENTER
    else if (key == ENTER) {
      if (indiceHistoria < historia.length - 1) {
        indiceHistoria++;
      } else {
        iniciarJogo(); // Inicia o jogo ao final da história
      }
    }
  }

  // Retornar ao menu principal a partir da tabela de recordes
  if (estado == 2 && key == ENTER) { 
    estado = 0; // Volta para o menu principal
  }

  // Entrada de números durante o jogo ativo
  if (estado == 3 && jogoAtivo) {
    if (key >= '0' && key <= '9') { 
      // Permite digitar até 3 números
      if (tentativaTexto.length() < 3) {
        tentativaTexto += key;
      }
    } 
    // Permite apagar números digitados
    else if (key == BACKSPACE && tentativaTexto.length() > 0) {
      tentativaTexto = tentativaTexto.substring(0, tentativaTexto.length() - 1);
    } 
    // Se ENTER for pressionado e houver uma tentativa válida
    else if (key == ENTER && tentativaTexto.length() > 0) {
      int tentativa = int(tentativaTexto);
      verificarTentativa(tentativa); // Verifica a tentativa
      tentativaTexto = ""; // Reseta o campo de entrada
    }
  }
}

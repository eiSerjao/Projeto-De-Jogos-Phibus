import java.util.ArrayList;
import java.util.Collections;


String nomeJogador = "";
boolean esperandoNome = true;
int estado = 0; // 0 = Menu, 1 = Jogo, 2 = Como Jogar, 3 = Sair
int indiceHistoria = 0;
String[] historia; // Array será gerado depois

int posicaoMarciano;  // Número onde o Marciano está escondido
int tentativasRestantes = 10;  // Número de tentativas disponíveis
boolean jogoAtivo = true;  // Controla se o jogo está ativo
String tentativaTexto = "";  // Armazena a tentativa do jogador antes de apertar ENTER
String mensagem = "";
boolean fimDeJogo = false;

int tempoInicio;
int tempoSaida = 0;

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

class Recorde {
  String nome;
  int tempo;

  Recorde(String nome, int tempo) {
    this.nome = nome;
    this.tempo = tempo;
  }
}

ArrayList<Recorde> recordes = new ArrayList<Recorde>();


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

void contarHistoria() {
  background(0);
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  
  float larguraTexto = 400; // Define a largura máxima do texto
  float alturaTexto = 200;  // Altura máxima do bloco de texto
  
  // Exibe o texto com quebra automática dentro da área definida
  text(historia[indiceHistoria], width / 2 - larguraTexto / 2, height / 2 - 50, larguraTexto, alturaTexto);

  textSize(16);
  text("Pressione ENTER ou clique para continuar...", width / 2, height - 50);
}
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

void keyPressed() {
  if (fimDeJogo) { 
    if (key == ENTER) {
      estado = 0;  // Voltar ao menu
      fimDeJogo = false; // Resetar o estado de fim de jogo
      mensagem = ""; // Limpar mensagem ao voltar ao menu
      
      // Resetar nome para permitir novo jogador
        nomeJogador = ""; 
        esperandoNome = true;
        
      // **Resetar o índice da história**
      indiceHistoria = 0;
    }
    return; // Impede que o resto do código continue
  }

  if (estado == 1) {
    if (esperandoNome) {
      if (key == BACKSPACE && nomeJogador.length() > 0) {
        nomeJogador = nomeJogador.substring(0, nomeJogador.length() - 1);
      } else if (key == ENTER && nomeJogador.length() > 0) {
        esperandoNome = false;
        gerarHistoria();
      } else if (key != BACKSPACE && key != ENTER && nomeJogador.length() < 10) {
        nomeJogador += key;
      }
    } else if (key == ENTER) {
      if (indiceHistoria < historia.length - 1) {
        indiceHistoria++;
      } else {
        iniciarJogo();
      }
    }
  }

  // **Mover a verificação do estado 2 para fora do bloco anterior**
  if (estado == 2 && key == ENTER) { 
    estado = 0; // Volta para o menu principal
  }

  if (estado == 3 && jogoAtivo) {
    if (key >= '0' && key <= '9') { 
      if (tentativaTexto.length() < 3) {
        tentativaTexto += key;
      }
    } 
    else if (key == BACKSPACE && tentativaTexto.length() > 0) {
      tentativaTexto = tentativaTexto.substring(0, tentativaTexto.length() - 1);
    } 
    else if (key == ENTER && tentativaTexto.length() > 0) {
      int tentativa = int(tentativaTexto);
      verificarTentativa(tentativa); 
      tentativaTexto = "";
    }
  }
}



void pedirNome() {
  background(0);
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Digite seu nome:", width / 2, height / 3);
  textSize(20);
  text(nomeJogador + "_", width / 2, height / 2);
}

void jogo() {
  if (esperandoNome) {
    pedirNome();
  } else {
    contarHistoria();
  }
}

void iniciarJogo() {
  estado = 3;  // Estado de jogo ativo
  posicaoMarciano = int(random(1, 101)); // Gera número entre 1 e 100
  tentativasRestantes = 10; // Reinicia as tentativas
  jogoAtivo = true;
  mensagem = "O jogo começou! O Marciano está escondido. Adivinhe de 1 a 100.";
  tempoInicio = millis(); // Registra o tempo de início do jogo

}

void verificarTentativa(int tentativa) {
    if (tentativa == posicaoMarciano) {
        int tempoFinal = millis();
        int tempoTotal = (tempoFinal - tempoInicio) / 1000;

        String mensagemRecorde = "";

        if (!recordes.isEmpty()) {
            // Obtemos o melhor tempo atual e quem o detém
            Recorde melhorRecorde = recordes.get(0);
            for (Recorde r : recordes) {
                if (r.tempo < melhorRecorde.tempo) {
                    melhorRecorde = r;
                }
            }

            // Se o novo tempo for menor, significa que temos um novo recorde!
            if (tempoTotal < melhorRecorde.tempo) {
                mensagemRecorde = "Novo recorde! Você ultrapassou " + melhorRecorde.nome + "!";
            }
        } else {
            mensagemRecorde = "Primeiro recorde registrado!";
        }

        mensagem = "Parabéns, " + nomeJogador + "! Você encontrou o Marciano! 🎉\n" + mensagemRecorde;
        jogoAtivo = false;
        fimDeJogo = true;

        // Adiciona o novo recorde
        recordes.add(new Recorde(nomeJogador, tempoTotal));
    } else {
        tentativasRestantes--;

        if (tentativa < posicaoMarciano) {
            mensagem = "O Marciano está em uma árvore MAIOR!";
        } else {
            mensagem = "O Marciano está em uma árvore MENOR!";
        }

        if (tentativasRestantes == 0) {
            mensagem = "Você perdeu! O Marciano mudou de lugar... 😢";
            posicaoMarciano = int(random(1, 101)); 
            tentativasRestantes = 10;
        }
    }
}



void iniciarPartida() {
  background(0);
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);

  if (jogoAtivo) {
    text("Tente encontrar o Marciano!", width / 2, height / 4);
    text("Digite um número entre 1 e 100", width / 2, height / 3);
    text("Tentativas restantes: " + tentativasRestantes, width / 2, height / 2);
    text("Seu palpite: " + tentativaTexto + "_", width / 2, height / 2 + 50);
  } else {
    textSize(20);
    String mensagemFim = "Fim de Jogo! Pressione ENTER para voltar ao menu.";

    if (mensagemFim.length() > 40) {
      String parte1 = mensagemFim.substring(0, 40);
      String parte2 = mensagemFim.substring(40);
      text(parte1, width / 2, height / 2);
      text(parte2, width / 2, height / 2 + 30);
    } else {
      text(mensagemFim, width / 2, height / 2);
    }
  }

  // **Exibir a mensagem dinâmica na parte inferior da tela**
  textSize(18);
  text(mensagem, width / 2, height - 40);  // Ajustado para evitar que saia da tela
}




void tabelaDeRecordes() {
  background(0, 0, 150);
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("🏆 Tabela de Recordes 🏆", width / 2, 50);
  
  // Ordenar a lista de recordes (menor tempo primeiro)
  Collections.sort(recordes, (a, b) -> a.tempo - b.tempo);

  textSize(20);
  int y = 100; // Posição inicial dos nomes na tela

  // Exibir os 5 melhores recordes
  for (int i = 0; i < min(5, recordes.size()); i++) {
    Recorde r = recordes.get(i);
    text((i + 1) + ". " + r.nome + " - " + r.tempo + "s", width / 2, y);
    y += 30;
  }

  textSize(16);
  text("Pressione ENTER para voltar ao menu", width / 2, height - 50);
}


void sair() {
  if (tempoSaida == 0) {
    tempoSaida = millis(); // Guarda o tempo atual quando a função for chamada
  }

  background(0);
  fill(255);
  textSize(32);
  textAlign(CENTER, CENTER);
  text("Até um outro Dia!", width / 2, height / 3);

  // Verifica se já passaram 2 segundos antes de fechar o jogo
  if (millis() - tempoSaida > 2000) {
    exit();
  }
}

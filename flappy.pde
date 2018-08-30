// KenMatsui

boolean gameOver = false;

BackGround backGround;
Pillar pillar1, pillar2, pillar3;
Bird bird;

void setup() {
  // display size
  size(540, 810);

  backGround = new BackGround();

  pillar1 = new Pillar(0);
  pillar2 = new Pillar(-200);
  pillar3 = new Pillar(-400);

  bird = new Bird();
}

void draw() {
  
  // 背景の表示
  backGround.display();
  // 柱の表示
  pillar1.display();
  pillar2.display();
  pillar3.display();
  // キャラの表示
  bird.display();

  // スコアの表示
  fill(255);
  textSize(30);
  text(pillar1.score + pillar2.score + pillar3.score, width/2, 80);
  
  if (gameOver == false) {
    // 背景の座標更新
    backGround.update();

    // 柱の座標更新
    pillar1.update();
    pillar2.update();
    pillar3.update();

    // 当たり判定
    if (pillar1.hit(bird.x, bird.y) || pillar2.hit(bird.x, bird.y) || pillar3.hit(bird.x, bird.y)) {
      // 強制的に下へたたきつける
      bird.vel = 20;
    } else {
      // 座標更新
      bird.update();
    }
    if (bird.y > 605) {
      gameOver = true;
    }

    // 移動
    bird.y += bird.vel;
  }
  else {
    bird.vel = 0;

    // GameOverの表示
    fill(255, 0, 0);
    textSize(70);
    text("GameOver", width/5.5, height/2);

    // REPLAYボタンの表示
    noStroke();
    fill(44, 62, 80);
    rect(170, 440, 200, 50);
    fill(26, 188, 156);
    // インタラクティブ
    if (mouseX > 170 && mouseX < 370 && mouseY > 440 && mouseY < 495) {
      textSize(40);
      text("REPLAY", 200, 479);
      if (mousePressed == true) {
        // REPLAYのために再初期化
        pillar1.reInit(0);
        pillar2.reInit(-200);
        pillar3.reInit(-400);
        bird.reInit();
        gameOver = false;
      }
    }
    else {
      textSize(30);
      text("REPLAY", 216, 475);
    }
  }
}

// --------------------背景--------------------
class BackGround {
  // 画像
  PImage img;
  // 速度
  float[] vel1;
  float[] vel2;
  float vel3 = -10;
  // 背景の四角の数
  int size = 27;

  // イメージの読み込みと値の設定
  BackGround() {
    img = loadImage("IMG_5837.PNG");

    vel1 = new float[size];
    vel2 = new float[size];

    int count1 = 0;
    int count2 = 0;
    for (int i = 0; i < width; i++) {
      if (i % 20 == 0) {
        vel1[count1] = i;
        count1++;
      } else if (i % 10 == 0) {
        vel2[count2] = i;
        count2++;
      }
    }
  }

  void update() {
    for (int i = 0; i < size; i++) {
      vel1[i] += 2;
      if (vel1[i] > width)
        vel1[i] -= width + 10;
    }
    for (int i = 0; i < size; ++i) {
      vel2[i] += 2;
      if (vel2[i] > width)
        vel2[i] -= width + 10;
    }
    vel3 += 2;
    if (vel3 > width)
      vel3 -= width + 10;
  }

  void display() {
    image(img, 0, 0, width, height);
    noStroke();

    fill(172, 226, 109);
    for (int i = 0; i < size; i++) {
      rect(vel1[i], 637, 15, 11);
    }
    fill(132, 188, 72);
    for (int i = 0; i < size; ++i) {
      rect(vel2[i], 637, 10, 11);
    }
    rect(vel3, 637, 10, 11);
  }
}

// ---------------------柱---------------------
class Pillar {
  // 上下それぞれのpillarの頂点
  PVector pillar1, pillar2;
  float space = 180;
  float wid = 80; // 幅
  float under = 631; // 柱の表示域
  float vel = 2; // 速度
  int score = 0; // スコア

  Pillar(float xpillar) {
    pillar1 = new PVector(xpillar, 1);
    pillar2 = new PVector(xpillar, random(300, 500));
  }

  void update() {
    // Animate
    pillar1.x += vel;
    pillar2.x += vel;
    if (pillar1.x > width) {
      pillar1.x = -wid;
    }
    if (pillar2.x > width) {
      pillar2.x = -wid;
      pillar2.y = random(300, 500);
    }
    if (pillar1.x == 300) {
      score++;
    }
  }

  void display() {
    noStroke();
    fill(132, 188, 72);

    // 上の柱
    rect(pillar1.x, pillar1.y, wid, pillar2.y - space);
    // 下の柱
    rect(pillar2.x, pillar2.y, wid, under - pillar2.y);
  }

  // 当たり判定
  boolean hit(float x, float y) {
    boolean hit = false;

    if (pillar1.x + wid > x-45 && pillar1.x < x) {
      if (pillar2.y-space > y-28 || pillar2.y < y + 20) {
        hit = true;
      }
    }
    return hit;
  }
  
  // 再初期化
  void reInit(float xpillar) {
    pillar1.x = xpillar;
    pillar1.y = 1;
    pillar2.x = xpillar;
    pillar2.y = random(300, 500);
    
    score = 0;
  }
}

// -------------------キャラ-------------------
class Bird {
  // 初期座標
  float x = width - 190;
  float y = 300;
  // 速度
  float vel = 0;
  // ノイズの種
  float yNoise = 0.0;
  // 羽の動き
  int wing = 0;

  Bird() {
  }

  void update() {
    // 上方向へのベクトル
    if (mousePressed == true)
      vel -= 1;

    // 重力
    vel += 0.098;
    // ノイズでゆらゆら
    yNoise += 0.1;
    y += noise(yNoise)*1;

    // 移動
    //y += vel;

    // 上を出ようとしない
    if (y < 0)
      vel = 3;
  }

  void display() {
    stroke(210, 105, 30);

    // 胴体
    fill(255, 215, 0);
    ellipse(x, y - 4.5, 45, 42);
    // 目
    fill(255);
    ellipse(x - 15, y - 15, 22.5, 30);
    fill(0);
    ellipse(x - 18, y - 13.5, 1.5, 4.5);
    // 口
    fill(255, 69, 0);
    ellipse(x - 18, y + 4.5, 25, 6);
    ellipse(x - 18, y + 9, 25, 6);
    // 羽
    fill(245, 222, 179);
    pushMatrix();
    translate(x, y);
    if (wing % 8 == 0) 
      rotate(-PI/5.0);
    else if (wing % 4 == 0) 
      rotate(PI/5.0);
    ellipse(18, 0, 30, 22.5);
    popMatrix();
    wing++;
    if (wing > 16)
      wing = 0;
  }
  
  // 再初期化
  void reInit() {
    // 初期座標
    x = width - 190;
    y = 300;
    // 速度
    vel = 0;
    // ノイズの種
    yNoise = 0.0;
  }
}
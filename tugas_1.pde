import processing.sound.*; // Import library Sound

PImage kecoaImage;
ArrayList<Cocroach> cocroachList;
int cocroachSpawnTimer = 0; 
SoundFile slapSound;

void setup() {
  size(800, 600);
  kecoaImage = loadImage("kecoa.png");
  cocroachList = new ArrayList<Cocroach>();
  
  slapSound = new SoundFile(this, "Slap SFX.mp3");
}

void draw() {
  background(255);

  // Menambah kecoa setiap 5 detik di posisi acak
  if (millis() - cocroachSpawnTimer >= 5000) {
    cocroachList.add(new Cocroach(random(100, width - 100), random(100, height - 100)));
    cocroachSpawnTimer = millis(); 
  }

  for (int i = cocroachList.size() - 1; i >= 0; i--) {
    Cocroach cocroach = cocroachList.get(i);
    cocroach.update();
    cocroach.display();
  }
}

class Cocroach {
  PVector position;
  PVector target;
  float speed = 2.0;
  float cocroachWidth = 100;
  float cocroachHeight = 100;
  float angle = 0;

  Cocroach(float x, float y) {
    position = new PVector(x, y);
    setNewTarget();
  }

  void setNewTarget() {
    target = new PVector(random(cocroachWidth / 2, width - cocroachWidth / 2), 
                         random(cocroachHeight / 2, height - cocroachHeight / 2));
  }

  void update() {
    PVector direction = PVector.sub(target, position);
    float distance = direction.mag();

    if (distance > speed) {
      direction.normalize();
      direction.mult(speed);
      position.add(direction);

      angle = atan2(direction.y, direction.x) + HALF_PI;
    } else {
      setNewTarget();
    }
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    imageMode(CENTER);
    image(kecoaImage, 0, 0, cocroachWidth, cocroachHeight);
    popMatrix();
  }

  boolean isHit(float mouseX, float mouseY) {
    return dist(mouseX, mouseY, position.x, position.y) < cocroachWidth / 2;
  }
}

// Event mouseClicked untuk memukul kecoa
void mouseClicked() {
  for (int i = cocroachList.size() - 1; i >= 0; i--) {
    Cocroach cocroach = cocroachList.get(i);
    if (cocroach.isHit(mouseX, mouseY)) {
      slapSound.stop();
      slapSound.play();
      cocroachList.remove(i);
      break;
    }
  }
}

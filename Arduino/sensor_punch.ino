#include <M5StickC.h>
// Bluetooth LE
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <CircularBuffer.h>

#define LOCAL_NAME                  "M5Stick-C m1"

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/
#define SERVICE_UUID                "f205b02c-ff08-11ea-adc1-0242ac120002"
#define CHARACTERISTIC_UUID      "f205b2e8-ff08-11ea-adc1-0242ac120002"

#define SIZE_BUF 100

BLEServer *pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
float roll, pitch, yaw;
float accX, accY, accZ;
bool isWaitingPunch = false;
CircularBuffer<float, SIZE_BUF> buf_pitch;
CircularBuffer<float, SIZE_BUF> buf_roll;

float temp = 0;
void setup() {
  M5.begin();
  M5.Lcd.setRotation(3);
  M5.Lcd.fillScreen(BLACK);
  M5.Lcd.setTextSize(1);
  M5.Lcd.setCursor(40, 0);
  M5.Lcd.println("M1 APP");
  M5.MPU6886.Init();
  initBLE();
}

void loop() {
  M5.MPU6886.getAhrsData(&pitch, &roll, &yaw);
  M5.MPU6886.getAccelData(&accX, &accY, &accZ);
  accX *= 1000; accY *= 1000; accZ *= 1000;
  buf_pitch.push(pitch);
  buf_roll.push(roll);

  Serial.printf("%5.1f,%5.1f,%5.1f\n", pitch, roll, yaw);
  M5.Lcd.setCursor(0, 15);
  M5.Lcd.printf("%.1f   %.1f   %.1f\n", accX , accY, accZ );
  M5.Lcd.setCursor(0, 30);
  M5.Lcd.printf("%5.1f,%5.1f,%5.1f\n", pitch, roll, yaw);

  if (isWaitingPunch == false) {
    isWaitingPunch = true;
    for (float i = SIZE_BUF; i >= 0; i--) {
      if (!near_zero(buf_pitch[i]) || !near_zero(buf_roll[i])) {
        isWaitingPunch = false;
        break;
      }
    }
  }

  if (isWaitingPunch == true) {
    pCharacteristic->setValue((std::string)"READY");
    pCharacteristic->notify();
    M5.Lcd.setCursor(0, 60);
    if (roll >= 25) {
      M5.Lcd.printf("LEFT");
      pCharacteristic->setValue((std::string)"LEFT");
      pCharacteristic->notify();
      isWaitingPunch = false;
    } else if (roll <= -30) {
      M5.Lcd.printf("RIGHT");
      pCharacteristic->setValue((std::string)"RIGHT");
      pCharacteristic->notify();
      isWaitingPunch = false;
    } else {
      M5.Lcd.printf("     ");
    }
  }

  if (deviceConnected) {
    if (M5.BtnB.wasPressed()) {
      M5.Lcd.setCursor(0, 60);
      M5.Lcd.println("Button B pressed!");
      pCharacteristic->setValue((std::string)"PressB*");
      pCharacteristic->notify();
    }
    if (M5.BtnA.wasPressed()) {
      M5.Lcd.setCursor(0, 60);
      M5.Lcd.println("Button A pressed!");
      pCharacteristic->setValue((std::string)"PressA*");
      pCharacteristic->notify();
    }
  }
  M5.update();

  delay(100);
}



// Bluetooth LE Change Connect State
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      M5.Lcd.fillScreen(BLACK);
      M5.Lcd.setCursor(50, 70);
      M5.Lcd.println("connect");
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      M5.Lcd.fillScreen(BLACK);
      M5.Lcd.setCursor(50, 70);
      M5.Lcd.println("disconnect");
      deviceConnected = false;
    }
};

// Bluetooth LE initialize
void initBLE() {
  BLEDevice::init("m5-stack");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  BLEService *pService = pServer->createService(SERVICE_UUID);
  pCharacteristic = pService->createCharacteristic(CHARACTERISTIC_UUID,
                    BLECharacteristic::PROPERTY_READ |
                    BLECharacteristic::PROPERTY_WRITE |
                    BLECharacteristic::PROPERTY_NOTIFY |
                    BLECharacteristic::PROPERTY_INDICATE
                                                  );
  pCharacteristic->addDescriptor(new BLE2902());

  pService->start();
  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();
}

bool near_zero(float value) {
  if (value > -15 && value < 15) {
    return true;
  } else {
    return false;
  }
}

<div id="top"></div>

# Recycle-Plus
- แอปพลิเคชั่นบนระบบ Android 
- ใช้ฐานข้อมูลบน Firebase
- ผสานการทำงานร่วมกันบนเครือข่าย Blockchain (xCHAIN) 
- [ขอบเขตการวิจัย](https://github.com/jakkaphatminthana/recycle_plus/files/8468961/default.pdf)

## รายละเอียด
- :heavy_check_mark: คือ ทำเเล้ว
- :x: คือ ยังไม่ได้ทำเเละจำเป็นต้องทำ
- :warning: คือ ยังไม่ได้ทำและไม่จำเป็นต้องทำตอนนี้

## สารบัญงาน
- หน้าจอของผู้ใช้
    - <p><a href="#Actor1"> Actor 1 : ผู้ใช้งานที่ไม่มีบัญชี </a></p>
    - <p><a href="#Actor2"> Actor 2 : ผู้ใช้งานที่ยังไม่ได้ยืนยันตัวตน </a></p>
    - <p><a href="#Actor3"> Actor 3 : สมาชิก </a></p>
    - <p><a href="#Actor4"> Actor 4 : สปอนเซอร์ </a></p>
    - <p><a href="#Actor5"> Actor 5 : ผู้ดูแลระบบ </a></p>
- <p><a href="#other"> ระบบเบื้องหลัง </a></p>
    


<p align="right">(<a href="#top">back to top</a>)</p>

<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor1"></div>

## Actor 1 : ผู้ใช้งานที่ไม่มีบัญชี

### หน้าเริ่มต้น
<img src="https://user-images.githubusercontent.com/58208814/161977181-cab5050b-7823-4706-a089-49dd8cd340ca.png" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :x: กดปุ่มแล้วไปที่ หน้าแรก

### หน้าแรก
<img src="https://user-images.githubusercontent.com/58208814/161980781-9b87cd48-9ac8-44e7-98c9-562437b46c65.png" width="250">

#### Front-end
- :x: Design
#### System
- :x: ไม่สามารถกดเมนูบน ข่าวสารได้ หากกดแล้วจะไปยัง "หน้าโปรดล็อคอิน" 
- :x: ไม่สามารถกดเมนูบน Appbar ได้หากกดแล้วจะไปยัง "หน้าโปรดล็อคอิน"
- :x: สามารถกด Tabbar
- :x: สามารถเข้าดูรายละเอียด ข่าวสารได้
- :warning: Wallet จะต้องไม่แสดงอะไร
- :warning: ดึงข้อมูล Sponsor จาก Firebase มาแสดง 
- :warning: ดึงข้อมูล ข่าวสาร จาก Firebase มาแสดง 

### หน้าโปรดเข้าสู่ระบบ
<img src="https://user-images.githubusercontent.com/58208814/162736334-6555d505-f613-49cb-9be3-e78a88eeb4bf.png" width="250">

#### Front-end
- :x: Design
#### System
- :x: กดปุ่ม "Login" แล้วไปยัง "หน้าเข้าสู่ระบบ" 
- :warning: กดปุ่ม "Back" แล้วไปยังหน้าที่แล้ว

### หน้าอ่านข่าวสาร
<img src="https://user-images.githubusercontent.com/58208814/162737293-205c64a2-859c-4be2-aa16-538a6d26cd37.png" width="250">

#### Front-end
- :x: Design
#### System
- :x: เชื่อมต่อ Firestore
    - :x: ดึงข้อมูลเนื้อหามาแสดง ของแต่ละข่าวสาร
- :warning: กดปุ่ม "Back" แล้วไปยังหน้าที่แล้ว

<p align="right">(<a href="#top">back to top</a>)</p>
<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor2"></div>

## Actor 2 : ผู้ใช้งานที่ยังไม่ได้ยืนยันตัวตน

### หน้าเข้าสู่ระบบ
<img src="https://user-images.githubusercontent.com/58208814/162963514-d384dd7e-d151-425c-a2e7-249dae6fc1ee.png" width="250">

#### Front-end
- :heavy_check_mark: Design
#### System
- :x: กดไอคอน "สมัครสมาชิก" แล้วไปยัง "หน้าสมัครสมาชิก" 
- :x: กดไอคอน "Google" แล้วไปยัง "การล็อคอินผ่าน Google" 
- :x: กดปุ่ม "Login" แล้วไปยัง "หน้าเข้าสู่ระบบสำเร็จ" 
- :x: เชื่อมต่อ Firebase Authentication
- :x: ล็อคอินผ่าน Firebase
- :x: validation from input 
    - :x: validation from email 
    - :x: validation from password
    - :x: แสดงข้อความ Error
- :x: validation login error
    - :x: validation email 
    - :x: validation password
    - :x: แสดงข้อความ Error

### หน้าสมัครสมาชิก
<img src="https://user-images.githubusercontent.com/58208814/162963631-3cd573da-de97-4609-96f1-a9b40a6918ff.png" width="250">

#### Front-end
- :x: Design
#### System
- :x: กดข้อความ "เข้าสู่ระบบ" แล้วไปยัง "หน้าเข้าสู่ระบบ" 
- :x: กดปุ่ม "Register" แล้วไปยัง "หน้าสมัครสมาชิกสำเร็จ" 
- :x: เชื่อมต่อ Firebase Authentication
- :x: สมัครสมาชิกผ่าน Firebase
- :x: validation from input 
    - :x: validation from email 
    - :x: validation from password
    - :x: แสดงข้อความ Error
- :x: validation login error
    - :x: validation email 
    - :x: validation password
    - :x: แสดงข้อความ Error

### หน้าสมัครสมาชิกสำเร็จ
#### Front-end
- :x: Design
#### System
- :x: กดปุ่ม "Back to login" แล้วไปยัง "หน้าเข้าสู่ระบบ" 

### หน้าเข้าสู่ระบบสำเร็จ
#### Front-end
- :x: Design
#### System
- :x: กดปุ่ม "Back to home" แล้วไปยัง "หน้าแรก" 

<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor3"></div>

## Actor 3 : สมาชิก

<p align="right">(<a href="#top">back to top</a>)</p>
<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor4"></div>

## Actor 4 : สปอนเซอร์

<p align="right">(<a href="#top">back to top</a>)</p>
<!------------------------------------------------------------------------------------------------------------------------>
<div id="Actor5"></div>

## Actor 5 : ผู้ดูแลระบบ

<p align="right">(<a href="#top">back to top</a>)</p>
<!------------------------------------------------------------------------------------------------------------------------>
<div id="other"></div>

## ระบบเบื้องหลัง

### Database
- :heavy_check_mark: เชื่อมต่อ Firebase App
- :x: เชื่อมต่อ Firebase Store
- :x: เชื่อมต่อ Firebase Auther
- :x: เชื่อมต่อ Blockchain

### เพิ่มเติม
- :x: กำหนด Route กำหนดหน้าจอ
- :x: กำหนด Constants Font
- :x: กำหนด Constants Font

<p align="right">(<a href="#top">back to top</a>)</p>
# دليل إنشاء Firebase Indexes

## متى تحتاج إلى Firebase Indexes؟

تحتاج إلى إنشاء index عندما تجمع بين:
1. **فلترة (where)** مع **ترتيب (orderBy)**
2. **فلترة متعددة (multiple where clauses)**
3. **فلترة على array fields**

## Indexes المطلوبة للمشروع الحالي

### 1. Products Collection Indexes

#### Index للاستعلام: `where isActive == true orderBy createdAt desc`
```
Collection: products
Fields:
- isActive (Ascending)
- createdAt (Descending)
- __name__ (Descending)
```

#### Index للاستعلام: `where isActive == true && isFeatured == true orderBy sellingCount desc`
```
Collection: products
Fields:
- isActive (Ascending)
- isFeatured (Ascending)
- sellingCount (Descending)
- __name__ (Descending)
```

#### Index للاستعلام: `where isActive == true orderBy sellingCount desc`
```
Collection: products
Fields:
- isActive (Ascending)
- sellingCount (Descending)
- __name__ (Descending)
```

## كيفية إنشاء Indexes

### الطريقة الأولى: من خلال Firebase Console

1. اذهب إلى [Firebase Console](https://console.firebase.google.com)
2. اختر مشروعك
3. اذهب إلى **Firestore Database**
4. اختر تبويب **Indexes**
5. اضغط **Create Index**
6. املأ البيانات المطلوبة

### الطريقة الثانية: من خلال Firebase CLI

1. أنشئ ملف `firestore.indexes.json` في مجلد المشروع:

```json
{
  "indexes": [
    {
      "collectionGroup": "products",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "isActive",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        },
        {
          "fieldPath": "__name__",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "products",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "isActive",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "isFeatured",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "sellingCount",
          "order": "DESCENDING"
        },
        {
          "fieldPath": "__name__",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "products",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "isActive",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "sellingCount",
          "order": "DESCENDING"
        },
        {
          "fieldPath": "__name__",
          "order": "DESCENDING"
        }
      ]
    }
  ]
}
```

2. ثم نفذ الأمر:
```bash
firebase deploy --only firestore:indexes
```

### الطريقة الثالثة: من خلال الرابط في الخطأ

عندما تظهر رسالة خطأ تحتوي على رابط، يمكنك:
1. نسخ الرابط من رسالة الخطأ
2. فتحه في المتصفح
3. الضغط على **Create Index**

## ملاحظات مهمة

1. **وقت الإنشاء**: قد يستغرق إنشاء الـ index عدة دقائق
2. **التكلفة**: الـ indexes تستهلك مساحة تخزين إضافية
3. **الأداء**: الـ indexes تحسن أداء الاستعلامات
4. **الحد الأقصى**: Firebase يسمح بـ 200 index لكل collection

## الحل البديل (المطبق حالياً)

بدلاً من إنشاء indexes، قمنا بتطبيق حل بديل:
1. جلب البيانات بدون ترتيب
2. الترتيب في الذاكرة (client-side sorting)

هذا الحل:
- ✅ لا يحتاج إلى indexes
- ✅ يعمل فوراً
- ✅ مناسب للبيانات الصغيرة والمتوسطة
- ❌ قد يكون أبطأ للبيانات الكبيرة جداً

## متى تستخدم كل حل؟

### استخدم Client-side Sorting عندما:
- عدد المنتجات أقل من 1000
- لا تحتاج إلى pagination
- تريد حل سريع

### استخدم Firebase Indexes عندما:
- عدد المنتجات كبير (أكثر من 1000)
- تحتاج إلى pagination
- تريد أداء أفضل
- لديك موارد كافية لإنشاء وصيانة الـ indexes 
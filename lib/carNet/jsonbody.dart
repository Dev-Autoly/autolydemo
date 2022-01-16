

// request url
String carNetUrl ="https://api.carnet.ai/v2/mmg/detect?box_offset=0&box_min_width=100&box_min_height=100&box_min_ratio=1&box_max_ratio=3"
    ".15&box_select=center&region=DEF";


// curl -X "POST" ^
// "https://api.carnet.ai/v2/mmg/detect?box_offset=0&box_min_width=180&box_min_height=180&box_min_ratio=1&box_max_ratio=3.15&box_select=center&region=DEF" ^
// -H "accept: application/json" ^
// -H "api-key: 32954476-72e5-47ae-9d27-4e0606735f2e" ^
// -H "Content-Type: application/octet-stream" ^
// -d ^
// "{}"


// {
//   "detections": [
//     {
//       "angle": [],
//       "box": {
//         "br_x": 0.7727,
//         "br_y": 0.7138,
//         "tl_x": 0.1868,
//         "tl_y": 0.1901
//       },
//       "class": {
//         "name": "car",
//         "probability": 0.997
//       },
//       "color": [],
//       "mm": [],
//       "mmg": [
//         {
//           "generation_id": 287,
//           "generation_name": "I (E83) facelift",
//           "make_id": 6,
//           "make_name": "BMW",
//           "model_id": 140,
//           "model_name": "X3",
//           "probability": 1,
//           "years": "2006-2010"
//         }
//       ],
//       "status": {
//         "code": 0,
//         "message": "",
//         "selected": true
//       },
//       "subclass": [
//         {
//           "name": "vehicle",
//           "probability": 1
//         }
//       ]
//     }
//   ],
//   "is_success": true,
//   "meta": {
//     "classifier": 2240,
//     "md5": "5CA592F5B456A126704F9E0A9FE65EE3",
//     "parameters": {
//       "box_max_ratio": 3.15,
//       "box_min_height": 180,
//       "box_min_ratio": 1,
//       "box_min_width": 180,
//       "box_select": "center",
//       "features": [
//         "mmg"
//       ],
//       "region": [
//         "DEF"
//       ]
//     },
//     "time": 0.12
//   }
// }

// sechema
// {
//   "is_success": true,
//   "error": {
//     "code": 2,
//     "message": "string"
//   },
//   "detections": [
//     {
//       "box": {
//         "br_x": 1,
//         "br_y": 1,
//         "tl_x": 1,
//         "tl_y": 1
//       },
//       "class": {
//         "name": "car",
//         "probability": 1
//       },
//       "subclass": [
//         {
//           "name": "vehicle",
//           "probability": 1
//         }
//       ],
//       "status": {
//         "code": 0,
//         "selected": true,
//         "message": "string"
//       },
//       "mm": [
//         {
//           "make_id": 0,
//           "make_name": "string",
//           "model_id": 0,
//           "model_name": "string",
//           "probability": 1
//         }
//       ],
//       "mmg": [
//         {
//           "make_id": 0,
//           "make_name": "string",
//           "model_id": 0,
//           "model_name": "string",
//           "generation_id": 0,
//           "generation_name": "string",
//           "years": "string",
//           "probability": 1
//         }
//       ],
//       "color": [
//         {
//           "id": 0,
//           "name": "string",
//           "probability": 1
//         }
//       ],
//       "angle": [
//         {
//           "name": "front",
//           "probability": 1
//         }
//       ]
//     }
//   ],
//   "meta": {
//     "classifier": 0,
//     "md5": "string",
//     "parameters": {
//       "box_max_ratio": 0,
//       "box_min_height": 0,
//       "box_min_ratio": 0,
//       "box_min_width": 0,
//       "box_offset": 0,
//       "box_select": "all",
//       "features": [
//         "mm"
//       ],
//       "region": [
//         "CIS"
//       ]
//     },
//     "time": 0
//   }
// }
import http from 'k6/http';
import { check } from 'k6';

export const options = {
  vus: 20,          // jumlah virtual user
  duration: '30s',  // durasi test

  thresholds: {
    http_req_failed: ['rate<0.01'],   // gagal kalau >1% request error
    http_req_duration: ['p(95)<1000'], // gagal kalau 95% request >1s
  },
};

export default function () {
  let res = http.get('http://10.10.3.40');
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
}


// import http from 'k6/http';
// import { check, sleep } from 'k6';

// export let options = {
//     vus: 10,          // jumlah virtual users
//     duration: '30s',  // durasi testing
// };

// export default function () {
//     let res = http.get('http://10.10.3.40/');
//     check(res, {
//         'status is 200': (r) => r.status === 200,
//     });
//     sleep(1);
// }


// import http from 'k6/http';
// import { check } from 'k6';

// export const options = {
//   thresholds: {
//     http_req_failed: ['rate<0.01'], // gagal kalau >1% request error
//     http_req_duration: ['p(95)<1000'], // gagal kalau 95% request >1s
//   },
// };

// export default function () {
//   let res = http.get('http://10.10.3.40');
//   check(res, {
//     'status is 200': (r) => r.status === 200,
//   });
// }

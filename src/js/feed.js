
function parse_snakecase(text) {
    return text.split('_').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
}

function cards() {
    const container = $('#card_container')
    const workouts = JSON.parse(localStorage.getItem('workouts'));

    Object.entries(workouts).forEach(([key, value]) => {

        const the_name = parse_snakecase(key);
        container.append(`
        <div class="col-md-4">
        <div class="card m-3" style="width: 18rem">
            <img src="${value.img}" class="card-img-top" alt="benchpress" />
            <div class="card-body bg-dark text-white">
                <h5 class="card-title">${the_name}</h5>
                <button class="btn btn-sm btn-warning see-details-btn" onclick="get_detail('${key}')">
                    See Details 
                </button>
            </div>
        </div>
    </div>
            `)
    })
}

function get_detail(det_key) {
    const db_url = `https://ambw-tes1-default-rtdb.asia-southeast1.firebasedatabase.app/details/det_${det_key}.json`;
    let data_ret = false;
    sessionStorage['current_page'] = det_key;

    if (!sessionStorage.getItem(det_key)) {
        fetch(db_url)
            .then(function (res) {
                return res.json();
            })
            .then(function (data) {
                data_ret = true;

                sessionStorage.setItem(det_key, JSON.stringify(data))
                window.location.href = 'details.html';
            })
            .catch(function (error) {
                window.location.href = 'offline.html';
            });
    } else {
        window.location.href = 'details.html';
    }
}

const cards_url = 'https://ambw-tes1-default-rtdb.asia-southeast1.firebasedatabase.app/cards.json';
let networkDataReceived = false;

if ('indexedDB' in window) {
    readAllData('workouts')
    .then(function (data) {
        console.log("data in indexedDB");
        console.log(data)
    });
}

if (!networkDataReceived) {
    fetch(cards_url)
    .then(function (res) {
        return res.json();
    })
    .then(function (data) {
        networkDataReceived = true;
        console.log("fetched data from web");
        console.log(data)
        localStorage.setItem('workouts', JSON.stringify(data));
    })
    .catch(function (error) {
        if (!localStorage.getItem('workouts')) {
            window.location.href = 'offline.html';
        }
    });
}





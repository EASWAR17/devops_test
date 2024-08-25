function sortImages() {
    const gallery = document.getElementById('imageGallery');
    const images = Array.from(gallery.getElementsByClassName('thumbnail'));
    const sortOption = document.getElementById('sortOptions').value;

    if (sortOption === 'recommended') {
        images.sort(() => Math.random() - 0.5); // Random order
    } else {
        images.sort((a, b) => {
            const aValue = parseInt(a.getAttribute(`data-${sortOption}`));
            const bValue = parseInt(b.getAttribute(`data-${sortOption}`));
            return bValue - aValue; // Descending order
        });
    }

    // Clear the gallery and append sorted images
    gallery.innerHTML = '';
    images.forEach(image => gallery.appendChild(image));

    // Apply grid layout dynamically
    applyGridLayout();
}

// Call sortImages when the webpage loads
window.addEventListener('load', sortImages);

// Call sortImages when the sort option changes
document.getElementById('sortOptions').addEventListener('change', sortImages);

document.addEventListener("DOMContentLoaded", function () {
    const searchInput = document.getElementById('searchInput');
    const searchByImageBtn = document.getElementById('searchByImage');
    const thumbnails = document.querySelectorAll('.thumbnail');
    const suggestions = document.getElementById('suggestions');

    searchInput.addEventListener('input', function () {
        showSuggestions(searchInput.value);
    });

    searchByImageBtn.addEventListener('click', function () {
        showImageSuggestions(searchInput.value);
    });

    function showSuggestions(value) {

        const searchInput = value.toLowerCase();
        const images = Array.from(document.getElementsByClassName('thumbnail'));
        const titles = images.map(image => image.querySelector('.thumbnail-info h4').innerText.toLowerCase());
        suggestions.innerHTML = '';

        if (searchInput) {
            const filteredTitles = titles.filter(title => title.includes(searchInput));
            filteredTitles.forEach(title => {
                const suggestionItem = document.createElement('div');
                suggestionItem.classList.add('suggestion-item');
                suggestionItem.innerText = title;
                suggestionItem.onclick = () => {
                    document.getElementById('searchInput').value = title;
                    suggestions.innerHTML = '';
                    // Display only the selected image

                    images.forEach(image => {
                        const imageTitle = image.querySelector('.thumbnail-info h4').innerText.toLowerCase();
                        if (imageTitle === title) {
                            image.style.display = 'block';
                        } else {
                            image.style.display = 'none';
                        }
                    });
                };
                suggestions.appendChild(suggestionItem);

            });
        } else {
            // If the search input is empty, display all images
            images.forEach(image => {
                image.style.display = 'block';
            });
        }
    }

    function showImageSuggestions(value) {

        const searchInput = value.toLowerCase();
        const images = Array.from(document.getElementsByClassName('thumbnail'));
        suggestions.innerHTML = '';

        if (searchInput) {
            images.forEach(image => {
                const imageTitle = image.querySelector('.thumbnail-info h4').innerText.toLowerCase();
                if (imageTitle.includes(searchInput)) {
                    image.style.display = 'block';

                } else {
                    image.style.display = 'none';
                }
            });
        } else {
            // If the search input is empty, display all images
            images.forEach(image => {
                image.style.display = 'block';
            });
        }
    }
});

function applyGridLayout() {
    const gallery = document.getElementById('imageGallery');
    gallery.style.display = 'grid';
    gallery.style.gridTemplateColumns = 'repeat(auto-fill, minmax(250px, 1fr))';
    gallery.style.gap = '10px';
    gallery.style.paddingLeft = '10px';
    gallery.style.paddingRight = '10px';
}


//img popup
document.addEventListener('DOMContentLoaded', function () {
    const thumbnails = document.querySelectorAll('.thumbnail-img img');
    const modal = document.getElementById('popup-modal');
    const modalImg = document.getElementById('popup-img');
    const closeBtn = document.querySelector('.close-btn');

    thumbnails.forEach(thumbnail => {
        thumbnail.addEventListener('click', function () {
            modal.style.display = 'flex';
            modal.style.alignItems = 'center';
            modal.style.justifyContent = 'space-around';
            modalImg.src = this.src;
        });
    });

    closeBtn.addEventListener('click', function () {
        modal.style.display = 'none';
    });

    window.addEventListener('click', function (event) {
        if (event.target === modal) {
            modal.style.display = 'none';
        }
    });
});

document.onreadystatechange = function () {
    if (document.readyState !== "complete") {
        document.querySelector(
            "body").style.visibility = "hidden";
        document.querySelector(
            "#loader").style.visibility = "visible";
    } else {
        document.querySelector(
            "#loader").style.display = "none";
        document.querySelector(
            "body").style.visibility = "visible";
    }
};

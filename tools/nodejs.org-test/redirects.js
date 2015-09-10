'use strict';

module.exports = {
    main: {
        301: [
            { src: 'http://nodejs.org/', dest: 'https://nodejs.org/' }
        ],
        302: [
            { src: 'https://nodejs.org/', dest: 'https://nodejs.org/en/' }
        ]
    },
    'blog': {
        301: [
            { src: 'http://blog.nodejs.org/', dest: 'https://nodejs.org/en/blog/' }
        ],
        302: [
            { src: 'https://blog.nodejs.org/', dest: 'https://nodejs.org/en/blog/' }
        ]
    },
    dist: {},
    docs: {}
};

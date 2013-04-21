'use strict';

var app = angular.module('gbg', ['gbg.services', 'gbg.directives']);

function ListCtrl($scope, $location, Boardgame) {

    $scope.bgs;
    $scope.bgFilters = {
        categories: {
            "Adventure": {checked: true},
            "Ancient/Mythology": {checked: true},
            "Card/Classic": {checked: true},
            "Economic/Political": {checked: true},
            "Family": {checked: true},
            "Fantasy/Sci-Fi": {checked: true},
            "Medieval/Cultural": {checked: true},
            "Miniatures/Expansions": {checked: true},
            "Modern Themes": {checked: true},
            "War": {checked: true}
        },
        initials: {
            age: 14,
            players: 6,
            time: 180
        }
    };

    var initialization = false;

    $scope.listNamespace = {
        page: 1,
        allBgs: [],
        currentFilters: {},
        grabbingBgs: false,
        getUrlFilters: function() {
            var params = $location.search();

            if (params.releaseDate) {
                $scope.bgFilters.filterYear = parseInt(params.releaseDate);
            }
            if (params.age) {
                $scope.bgFilters.initials.age = parseInt(params.age);
            }
            if (params.players) {
                $scope.bgFilters.initials.players = parseInt(params.players);
            }
            if (params.time) {
                $scope.bgFilters.initials.time = parseInt(params.time);
            }
            if (params.noCats) {
                var cats = params.noCats.split(',');

                _.each(cats, function(c) {
                    $scope.bgFilters.categories[c].checked = false;
                })
            }
        },
        filter: function() {
            $scope.filtering = true;
            var newbgs = $scope.listNamespace.allBgs;

            newbgs = _.filter(newbgs, function(b) {

                if ( !b.category ) { return false; }

                var returnee = true;

                if ( $scope.listNamespace.currentFilters.filterYear ) {
                    var year = parseInt(b.year);
                    returnee = returnee && year >= 2013-$scope.listNamespace.currentFilters.filterYear;
                }

                var age = parseInt(b.age);
                returnee = returnee && age <= $scope.listNamespace.currentFilters.filterAge;

                if ($scope.listNamespace.currentFilters.filterPlayers < 10) {
                    returnee = returnee && b.maxPlayers <= $scope.listNamespace.currentFilters.filterPlayers;
                }

                if ($scope.listNamespace.currentFilters.filterTime < 180) {
                    returnee = returnee && b.time <= $scope.listNamespace.currentFilters.filterTime;
                }

                if ($scope.listNamespace.currentFilters.categories[b.category]) {
                    returnee = returnee && $scope.listNamespace.currentFilters.categories[b.category].checked;
                }

                return returnee;
            });
            $scope.bgs = _.sortBy(newbgs, function(bg) { return parseFloat(bg.rating) }).reverse();
            $scope.filtering = false;

            if ($scope.bgs.length < 10 && initialization) {
                $scope.listNamespace.getNextPage();
            }

            return $scope.bgs;
        },
        getNextPage: function() {
            console.log('har');

            if ( !$scope.filtering ) {
                $scope.filtering = true;

                Boardgame.get($scope.listNamespace.page).then(function(data) {
                    $scope.listNamespace.page++;
                    $scope.listNamespace.allBgs = $scope.listNamespace.allBgs.concat(data.bgs);
                    initialization = true;
                    $scope.listNamespace.filter();
                });
            }
        }
    }

    $scope.$watch("bgFilters.filterYear", function(val) {
        var year = parseInt(val);

        if (year) {
            console.log(year);
            $scope.listNamespace.currentFilters.filterYear = year;
        }
        else {
            delete $scope.listNamespace.currentFilters.filterYear;
        }
        $scope.listNamespace.filter();
    });

    $scope.$watch("bgFilters.filterAge", function(val) {

        var age = parseInt(val);
        $scope.listNamespace.currentFilters.filterAge = age;
        $scope.listNamespace.filter();
    });

    $scope.$watch("bgFilters.filterPlayers", function(val) {

        var players = parseInt(val);
        $scope.listNamespace.currentFilters.filterPlayers = players;
        $scope.listNamespace.filter();
    });

    $scope.$watch("bgFilters.filterTime", function(val) {

        var time = parseInt(val);
        $scope.listNamespace.currentFilters.filterTime = time;
        $scope.listNamespace.filter();
    });

    $scope.$watch("bgFilters.categories", function(val) {

        $scope.listNamespace.currentFilters.categories = val;
        $scope.listNamespace.filter();
    }, true);

    $scope.listNamespace.getNextPage();
    $scope.listNamespace.getUrlFilters();

    $scope.logConsole = function() {
        console.log($scope);
        console.log($location.search());
    }
}

angular.module('gbg.services', [], function($provide) {
    $provide.factory('Boardgame', function($http) {
        var Boardgame = function(data) {
            angular.extend(this, data);
        }

        Boardgame.get = function(page) {
            return $http.get('/api/bg?page='+page).then(function(response) {
                return new Boardgame(response.data);
            })
        }

        return Boardgame;
    });
});

angular.module('gbg.directives', []).
    directive('popUp', function(){
        return {
            restrict: 'A',
            link: function($scope, $element, $attrs){
                $element.click(function(){
                    console.log('popping', $attrs.popUp);
                    window.open(encodeURI($attrs.popUp),'mywindow','width='+$attrs.width+',height='+$attrs.height);
                });
            }
        }
    }).
    directive('scrolly', function() {
        return {
            restrict: "A",
            scope: {
                scrolly: '&'
            },
            link: function (scope, element, attrs) {

                $(window).scroll(function() {
                    if (distanceToBottom() <= 500) {
                        scope.scrolly();
                    }
                });

                function distanceToBottom() {
                    var scrollPosition = window.pageYOffset;
                    var windowSize     = window.innerHeight;
                    var bodyHeight     = document.body.offsetHeight;

                    return Math.max(bodyHeight - (scrollPosition + windowSize), 0);
                }
            }
        }
    }).
    directive('slider', function () {
        return {
            restrict: "A",
            scope: {
                sliderValue: '=',
                sliderType: '@',
                min: '@',
                max: '@',
                step: '@',
                initial: '='
            },
            controller: function ($scope, $element, $attrs) {
                var min = parseInt($attrs.min);
                var max = parseInt($attrs.max);
                var range = true;
                var value;

                if ($attrs.sliderType == 'single') {
                    range = 'min';
                    value = parseInt($scope.initial);
                    $scope.sliderValue = value;
                    $scope.sliderDisplay = value;
                }
                else if ($attrs.sliderType == 'double') {
                    range= true;
                    value = [2,5];
                    $scope.sliderValue = value;
                    $scope.sliderDisplay = value;
                }

                $element.children('.slider').slider({
                    step: parseInt($attrs.step),
                    range: range,
                    min: min,
                    max: max,
                    value: parseInt($scope.initial),
                    values: value,
                    slide: function(event, ui) {

                        if ($attrs.sliderType == 'single') {
                            $scope.sliderDisplay = ui.value;
                        }
                        else if ($attrs.sliderType == 'double') {
                            $scope.sliderDisplay = ui.values;
                        }

                        $scope.$apply();
                    },
                    change: function(event, ui) {

                        if ($attrs.sliderType == 'single') {
                            $scope.sliderValue = ui.value;
                        }
                        else if ($attrs.sliderType == 'double') {
                            $scope.sliderValue = ui.values;
                        }
                        $scope.$apply();
                    }
                });
            }
        }
    });

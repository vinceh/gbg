'use strict';

var app = angular.module('gbg', ['gbg.services']);

function ListCtrl($scope, $location, Boardgame) {

    $scope.bgs;

    var listNamespace = {
        page: 1,
        allBgs: [],
        currentFilters: {},
        grabbingBgs: false,
        getUrlFilters: function() {

        },
        filter: function() {
            $scope.bgs = listNamespace.allBgs;
            if ( listNamespace.currentFilters.filterYear ) {
                console.log($scope.bgs);
                $scope.bgs = _.filter($scope.bgs, function(b) {
                    var year = parseInt(b.year);
                    return year >= 2013-listNamespace.currentFilters.filterYear;
                });
            }
            $scope.bgs = _.sortBy($scope.bgs, function(bg) { return parseFloat(bg.rating) }).reverse();
            return $scope.bgs;
        },
        getNextPage: function() {
            Boardgame.get(listNamespace.page).then(function(data) {
                listNamespace.page++;
                listNamespace.allBgs = listNamespace.allBgs.concat(data.bgs);
                var newset = listNamespace.filter();
                if (newset.length < 10) {
                    listNamespace.getNextPage();
                }
            });
        }
    }

    $scope.$watch("filterYear", function(val) {
        var year = parseInt(val);

        if (year) {
            listNamespace.currentFilters.filterYear = year;
        }
        else {
            delete listNamespace.currentFilters.filterYear;
        }
        listNamespace.filter();
    });

    listNamespace.getNextPage();
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

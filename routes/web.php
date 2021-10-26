<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/categories', function () {
     $client = \Softonic\GraphQL\ClientBuilder::build('https://api.shop.rossmann.beta.big.hu/graphql');

    $query = '
        query {
            categories {
                id
                title
            }
        }
    ';

    /*
    $variables = [
        'idFoo' => 'foo',
        'idBar' => 'bar',
    ];
    */
    // $response = $client->query($query, $variables);
    $response = $client->query($query);
    dd($response->getData());
});
